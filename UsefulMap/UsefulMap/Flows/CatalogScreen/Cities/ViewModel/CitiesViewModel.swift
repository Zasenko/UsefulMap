//
//  CitiesViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import SwiftUI

class CitiesViewModel {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    @Binding var country: Country
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, country: Binding<Country>) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        self._country = country
    }
}

extension CitiesViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchCitiesByCountryId() async {
        do {
            country.cities = try await networkManager.getAllCitiesByCountryId(countryId: country.id)
        } catch {
            debugPrint("Error: ", error)
        }
    }
}
