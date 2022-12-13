//
//  CitiesViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import Foundation

class CitiesViewModel {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
    }
}

extension CitiesViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchCitiesByCountryId(countryId: Int) async -> Cities {
        do {
            let cities = try await networkManager.getAllCitiesByCountryId(countryId: countryId)
            return cities
        } catch {
            debugPrint("Error: ", error)
            return []
        }
    }
}
