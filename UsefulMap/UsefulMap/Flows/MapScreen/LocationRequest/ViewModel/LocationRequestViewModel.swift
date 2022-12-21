//
//  LocationRequestViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import Foundation
import CoreLocation

class LocationRequestViewModel: NSObject, ObservableObject {
    
    //MARK: - Properties
    
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var authorizationStatus: CLAuthorizationStatus

    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Private properties
    
    var locationManager: CLLocationManager
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
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
        userLocation = location
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
}
