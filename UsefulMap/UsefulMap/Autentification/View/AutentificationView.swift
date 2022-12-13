//
//  AutentificationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import SwiftUI

struct AutentificationView: View {
    
    //MARK: - Properties
    
    let userViewModel = UserViewModel()
    let networkManager = NetworkManager()
    
    //MARK: - Private properties
    
    @State private var isLocationViewOpen = false
    
    //MARK: - Body
    
    var body: some View {
        if isLocationViewOpen {
            LocationRequestView(networkManager: networkManager, userViewModel: userViewModel)
        } else {
            LoginView(userViewModel: userViewModel, networkManager: networkManager, isLocationViewOpen: $isLocationViewOpen)
        }
    }
}
