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
    
    //MARK: - Body
    
    var body: some View {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            AppImages.mapBackground
                .resizable()
                .blur(radius: 10)
                .ignoresSafeArea()
        case .restricted, .denied:
            СountriesView(viewModel: СountriesViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel))
        case .authorizedAlways, .authorizedWhenInUse:
            LocationsMapView(viewModel: LocationsMapViewModel(networkManager: viewModel.networkManager,
                                                              userViewModel: viewModel.userViewModel),
                             locationRequestviewModel: viewModel
            )
        default:
            СountriesView(viewModel: СountriesViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel))
        }
    }
}

