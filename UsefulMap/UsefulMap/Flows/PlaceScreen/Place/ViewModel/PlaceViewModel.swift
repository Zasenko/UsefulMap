//
//  PlaceViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import Foundation
import SwiftUI

class PlaceViewModel {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    @Binding var place: Place
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, place: Binding<Place>) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        _place = place
    }
}

extension PlaceViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func fetchPlaceById() async {
        if place.description == nil {
            do {
                var decodedPlace = try await networkManager.getPlaceInfoById(placeId: place.id)
                guard let userLikedPlace = userViewModel.user.savedPlaces,
                      userLikedPlace.count > 0 else {
                    place = decodedPlace
                    return
                }
                if userLikedPlace.contains(where: {$0.id == decodedPlace.id } ) {
                    decodedPlace.isLiked.toggle()
                }
                place = decodedPlace
            } catch {
                debugPrint("Error: ", error)
            }
        }
    }
    
    @MainActor
    func likePlace() async {
        guard let userId = userViewModel.user.id else {
            return
        }
        do {
            let result = try await networkManager.likePlace(placeId: place.id, userId: userId)
            switch result.result {
            case .error:
                return
            case .liked:
                userViewModel.likePlace(placeId: place.id)
                place.isLiked = true
            case .disliked:
                userViewModel.dislikePlace(placeId: place.id)
                place.isLiked = false
            }
        } catch {
            debugPrint("Error: ", error)
        }
    }
    
    func call() {
        guard let placePhone = place.phone else {
            return
        }
        let phone = "tel://"
        let phoneNumberformatted = phone + "+\(placePhone)"
        guard let url = URL(string: phoneNumberformatted) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func getUrl(url string: String) -> URL? {
        return URL(string: string) ?? nil
    }
}
