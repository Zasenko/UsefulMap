//
//  AutentificationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import SwiftUI

struct AuthenticationView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    //MARK: - Body
    
    var body: some View {
        if viewModel.isLocationViewOpen {
            LocationRequestView(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel)
            .environmentObject(viewModel)
        } else {
            LoginView(userViewModel: viewModel.userViewModel, networkManager: viewModel.networkManager, isLocationViewOpen: $viewModel.isLocationViewOpen)
        }
    }
}
