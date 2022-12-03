//
//  LocationManager.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    //MARK: - Properties
    
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.26378869152448, longitude: 16.45253541423157)
    @Published var authorizationStatus: CLAuthorizationStatus
    
    //MARK: - Private properties
    
    private let locationManager: CLLocationManager
    
    //MARK: - Init

    override init() {
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

//MARK: - Delegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        guard let location = locations.last?.coordinate else { return }
        DispatchQueue.main.async {
            self.userLocation = location
            self.locationManager.stopUpdatingLocation()
        }
    }
}
    
//MARK: - Private functions

extension LocationManager {
    
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
