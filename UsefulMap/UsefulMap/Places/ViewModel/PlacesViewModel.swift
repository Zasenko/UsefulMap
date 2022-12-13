//
//  PlacesViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import Foundation

class PlacesViewModel {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
    }
}

extension PlacesViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchPlacesByCityId(cityId: Int) async -> Places {
        do {
            let places = try await networkManager.getAllPlacesByCityId(cityId: cityId)
            return places
        } catch {
            debugPrint("Error: ", error)
            return []
        }
    }
}
