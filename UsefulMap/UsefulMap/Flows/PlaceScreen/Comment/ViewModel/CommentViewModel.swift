//
//  CommentViewModel.swift
//  UsefulMap
//
//  Created by Eduard on 19.12.2022.
//

import SwiftUI


class CommentViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let authenticationViewModel: AuthenticationViewModel
    
    @Binding var comment: Comment

    @Published var isCommentLike = false
    @Published var error = ""
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager,
         comment: Binding<Comment>,
         authenticationViewModel: AuthenticationViewModel) {
        self.networkManager = networkManager
        self._comment = comment
        self.authenticationViewModel = authenticationViewModel
    }
}

extension CommentViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func setResetCommentLike(userID: Int?) async {
        do {
            if comment.userName != authenticationViewModel.userViewModel.user.name,
               let userID = userID {
                let setResetCommentLikeResult = try await networkManager.setResetCommentLike(commentID: String(comment.id), userID: userID)
                switch setResetCommentLikeResult.result {
                case 0 :
                    error = setResetCommentLikeResult.error ?? ""
                case 1:
                    isCommentLike = true
                    comment.isCommentLikeCurrentUser = true
                    comment.likesCount += 1
                    authenticationViewModel.userViewModel.updateLikedUserComments(commentID: comment.id)
                default:
                    isCommentLike = false
                    comment.isCommentLikeCurrentUser = false
                    comment.likesCount -= 1
                    authenticationViewModel.userViewModel.updateLikedUserComments(commentID: comment.id)
                }
            }
        } catch {
            print("Error:---", error)
        }
    }
    
    func commentViewLikesInitialization() {
        if let userLikedComments = authenticationViewModel.userViewModel.user.likedComments,
           userLikedComments.count > 0,
           userLikedComments.contains(where: {$0.id == comment.id})
        {
            comment.isCommentLikeCurrentUser = true
        }
        isCommentLike = comment.isCommentLikeCurrentUser
    }
}
