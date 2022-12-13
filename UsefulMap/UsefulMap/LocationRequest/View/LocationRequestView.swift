//
//  LocationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct LocationRequestView: View {
    
    //MARK: - Properties
    
    @StateObject var locationManager: LocationManager
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        self._locationManager = StateObject(wrappedValue: LocationManager(networkManager: networkManager))
        }
    
    //MARK: - Body
    
    var body: some View {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            Image("map")
                .resizable()
                .blur(radius: 10)
                .ignoresSafeArea()
        case .restricted, .denied:
            СountriesView(networkManager: networkManager, userViewModel: userViewModel)
        case .authorizedAlways, .authorizedWhenInUse:
            LocationsMapView(locationManager: locationManager, userViewModel: userViewModel)
        default:
            СountriesView(networkManager: networkManager, userViewModel: userViewModel)
        }
    }
}

