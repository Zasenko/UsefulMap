//
//  UserViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import Foundation

class UserViewModel {
    
    //MARK: - Private properties
    
    private let userMomento = Momento()
    
    private(set) var user: User {
        didSet {
            userMomento.save(user: self.user)
        }
    }
    
    //MARK: - Init

    init() {
        self.user = self.userMomento.loadUser()
    }
}

extension UserViewModel {
    
    //MARK: - Functions
    
    func saveUser(user: User) {
        userMomento.save(user: user)
        self.user = user
    }

    func isUserLoggedIn() -> Bool {
        return user.id != nil
    }
    
    func likePlace(placeId: Int) {
        self.user.savedPlaces?.append(UserPlace(id: placeId))
    }
    
    func dislikePlace(placeId: Int) {
        self.user.savedPlaces?.removeAll(where: { $0.id == placeId } )//.append(UserPlace(id: placeId))
    }
    
    func updateLikedUserComments(commentID: Int) {
        user = userMomento.updateLikedUserComments(user: user, commentID: commentID)
        saveUser(user: user)
    }
    
    func checkAndGetPlacesWithLikes(places: Places) async -> Places? {
        guard let userLikedPlace = user.savedPlaces, userLikedPlace.count > 0 else {
            return nil
        }
        let placesId = places.map { $0.id }
        let userLikedPlaceId = userLikedPlace.map { $0.id }
        if await checkLikesCoincidence(userPlacesId: placesId, placesId: userLikedPlaceId) {
            return await changingLikeStatusInPlaces(places: places, userLikedPlaceId: userLikedPlaceId)
        } else {
            return nil
        }
    }
    
    func checkIfPlaceiSLiked(placeId: Int) async -> Bool {
        guard let userLikedPlaces = user.savedPlaces, userLikedPlaces.count > 0 else {
            return false
        }
        guard let isLaked = user.savedPlaces?.contains(where: { $0.id == placeId } ) else {
            return false
        }
        if isLaked {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Private functions
    
    private func checkLikesCoincidence(userPlacesId: [Int], placesId: [Int]) async -> Bool {
        return userPlacesId.filter { placesId.contains($0) }.count > 0
    }
    
    private func changingLikeStatusInPlaces(places: Places, userLikedPlaceId: [Int]) async -> Places {
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
