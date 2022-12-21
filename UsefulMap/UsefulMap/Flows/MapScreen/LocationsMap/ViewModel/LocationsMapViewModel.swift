//
//  LocationsMapViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 20.12.22.
//

import Foundation

class LocationsMapViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var locations: Places = []
    @Published var isLocationFound: Bool = true
    @Published var selectedCategory: PlaceType? = nil
    @Published var filteredPlaces: Places = []
    @Published var placeCategories: [PlaceType] = []
    @Published var celectedLocation: Place? = nil
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
    }
}

extension LocationsMapViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchPlacesByUserLocation(latitude: Double, longitude: Double) async {
         do {
             let places = try await networkManager.getAllPlacesByUserLocation(latitude: latitude, longitude: longitude)
             if places.isEmpty {
                isLocationFound = false
             } else {
                 locations = places
                 filteredPlaces = places
                 placeCategories = places.map( { $0.type} ).uniqued()
             }
         } catch {
             debugPrint("Error: ", error)
         }
     }
}
