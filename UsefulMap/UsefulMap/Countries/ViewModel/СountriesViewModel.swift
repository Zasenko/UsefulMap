//
//  СountriesViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import Foundation

class СountriesViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    @Published var countries: Countries = []
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
    }
}

extension СountriesViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchCountries() async {
        do {
            countries = try await networkManager.getAllCountries()
        } catch {
            debugPrint("Error: ", error)
        }
    }
}
