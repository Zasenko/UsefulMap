//
//  PlaceViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import Foundation

class PlaceViewModel {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
    }
}

extension PlaceViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchPlaceById(placeId: Int, place: Place) async -> Place {
        do {
            return try await networkManager.getPlaceInfoById(placeId: placeId)
        } catch {
            debugPrint("Error: ", error)
            return place
        }
    }
}
