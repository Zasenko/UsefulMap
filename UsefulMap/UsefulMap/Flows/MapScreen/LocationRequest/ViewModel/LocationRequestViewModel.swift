//
//  LocationRequestViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import Foundation
import CoreLocation

@MainActor
class LocationRequestViewModel: NSObject, ObservableObject {
    
    //MARK: - Properties
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var locations: Places = []
    @Published var isLocationFound: Bool = true
    @Published var selectedCategory: PlaceType? = nil
    @Published var filteredPlaces: Places = []
    @Published var placeCategories: [PlaceType] = []

    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Private properties
    
    private var locationManager: CLLocationManager
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
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

extension LocationRequestViewModel: CLLocationManagerDelegate {
    
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
                self.filteredPlaces = foundLocations
                self.placeCategories = foundLocations.map( { $0.type} ).uniqued()
            }
        }
    }
}

extension LocationRequestViewModel {
    
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
