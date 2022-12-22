//
//  PlacesViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import SwiftUI

class PlacesViewModel {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    @Binding var city: City
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, city: Binding<City>) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        _city = city
    }
}

extension PlacesViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchPlacesByCityId() async {
        if city.places.isEmpty {
            do {
                let places = try await networkManager.getAllPlacesByCityId(cityId: city.id)
                if let likedPlaces = await userViewModel.checkAndGetPlacesWithLikes(places: city.places) {
                    city.places = likedPlaces
                    return
                }
                city.places = places
            } catch {
                debugPrint("Error: ", error)
                city.places = []
            }
        }
    }
}
