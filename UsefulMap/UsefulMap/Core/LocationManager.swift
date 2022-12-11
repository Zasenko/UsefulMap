//
//  LocationManager.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import Foundation
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject {
    
    //MARK: - Properties
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var locations: Places = []
    
    let networkManager: NetworkManager
    
    //MARK: - Private properties
    
    private var locationManager: CLLocationManager
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.locationManager = CLLocationManager()
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        checkLocationAutorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else {
            return
        }
        self.userLocation = location
        self.locationManager.stopUpdatingLocation()
        Task {
            self.locations = await fetchPlacesByUserLocation(latitude: location.latitude, longitude: location.longitude)
        }
    }
}

extension LocationManager {
    
    //MARK: - Private functions
    
    private func checkLocationAutorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            authorizationStatus = locationManager.authorizationStatus
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationStatus = locationManager.authorizationStatus
        @unknown default:
            break
        }
    }
    
    private func fetchPlacesByUserLocation(latitude: Double, longitude: Double) async -> Places {
        do {
            let decodedPlaces = try await networkManager.getAllPlacesByUserLocation(latitude: latitude, longitude: longitude)
            let places = await covertDecodedPlacestoPlaces(decodedPlaces: decodedPlaces)
            return places
        } catch {
            debugPrint("Error: ", error)
            return []
        }
    }

    private func covertDecodedPlacestoPlaces(decodedPlaces: DecodedPlaces) async -> Places {
        var places: Places = []
        for i in decodedPlaces {
            let place = Place(id: i.id, name: i.name, type: i.type, address: i.address, coordinate: CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude), photo: i.photo)
            places.append(place)
        }
        return places
    }
}
