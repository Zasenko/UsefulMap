//
//  AutentificationViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let userViewModel = UserViewModel()
    let networkManager = NetworkManager()
    
    @Published var isLocationViewOpen = false
}
