//
//  LocationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct LocationRequestView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: LocationRequestViewModel
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: LocationRequestViewModel(networkManager: networkManager, userViewModel: userViewModel))
        }
    
    //MARK: - Body
    
    var body: some View {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            AppImages.mapBackground
                .resizable()
                .blur(radius: 10)
                .ignoresSafeArea()
        case .restricted, .denied:
            СountriesView(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel)
        case .authorizedAlways, .authorizedWhenInUse:
            LocationsMapView(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, locationRequestviewModel: viewModel)
        default:
            СountriesView(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel)
        }
    }
}

