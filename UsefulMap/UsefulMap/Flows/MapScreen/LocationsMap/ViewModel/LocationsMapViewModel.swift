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
                return
            }
            if let likedPlaces = await userViewModel.checkAndGetPlacesWithLikes(places: places) {
                locations = likedPlaces
                filteredPlaces = likedPlaces
                placeCategories = likedPlaces.map( { $0.type} ).uniqued()
                return
            }
            locations = places
            filteredPlaces = places
            placeCategories = places.map( { $0.type} ).uniqued()
        } catch {
            debugPrint("Error: ", error)
            isLocationFound = false
        }
    }
    
    @MainActor
    func checkLikePlaceStatus() async {
        guard let sel = celectedLocation?.id else { return }
        if await userViewModel.checkIfPlaceiSLiked(placeId: sel) {
            celectedLocation?.isLiked = true
        }
    }
    
    //MARK: - Private functions
    
    private func checkLikesCoincidence(userPlacesId: [Int], placesId: [Int]) async -> Bool {
        return userPlacesId.filter { placesId.contains($0) }.count > 0
    }
    
    private func changingLikeStatus(places: Places, userLikedPlaceId: [Int]) async -> Places {
        var newPlaces: Places = []
        for i in places {
            var place = i
            if userLikedPlaceId.contains(where: {$0 == i.id }) {
                place.isLiked.toggle()
            }
            newPlaces.append(place)
        }
        return newPlaces
    }
}
