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
    @Published var isLocationFound: Bool = true
    
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
    
    //MARK: - Functions
    
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
            let foundLocations = await fetchPlacesByUserLocation(latitude: location.latitude, longitude: location.longitude)
            if foundLocations.isEmpty {
                self.isLocationFound = false
            } else {
                self.locations = foundLocations
            }
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
            let places = try await networkManager.getAllPlacesByUserLocation(latitude: latitude, longitude: longitude)
            return places
        } catch {
            debugPrint("Error: ", error)
            return []
        }
    }
}
