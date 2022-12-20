//
//  CommentsViewModel.swift
//  UsefulMap
//
//  Created by Eduard on 16.12.2022.
//

import SwiftUI


class CommentsViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel

    @Published var isUserNotLoggedIn: Bool
    @Published var newCommentText: String = ""
    @Published var error = ""
    @Published var isUserLeftComment = false
    
    @Binding var place: Place
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, place: Binding<Place>) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        self.isUserNotLoggedIn = !userViewModel.isUserLoggedIn()
        self._place = place
    }
}

extension CommentsViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func addComment(placeID: Int, userID: Int) async {
        do {
            let addCommentResult = try await networkManager.addComment(placeID: placeID, text: newCommentText, userID: userID )
            if addCommentResult.result == 0 {
                error = addCommentResult.error ?? ""
            } else {
                place = try await networkManager.getPlaceInfoById(placeId: placeID)
            }
        } catch {
            print("Error:---", error)
        }
    }
    
    func isUserLeftCommentFunc() {
        if place.comments?.first(where: {$0.userName == userViewModel.user.name}) != nil {
            isUserLeftComment = true
        }
    }
}
