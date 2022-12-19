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
    @Binding var comment: Comment

    @Published var isCommentLike = false
    @Published var error = ""
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, comment: Binding<Comment>) {
        self.networkManager = networkManager
        self._comment = comment
    }
}

extension CommentViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func setResetCommentLike(userID: Int?) async {
        do {
            if let userID = userID {
                let setResetCommentLikeResult = try await networkManager.setResetCommentLike(commentID: String(comment.id), userID: userID)
                switch setResetCommentLikeResult.result {
                case 0 :
                    error = setResetCommentLikeResult.error ?? ""
                case 1:
                    isCommentLike = true
                    comment.likesCount += 1
                default:
                    isCommentLike = false
                    comment.likesCount -= 1
                }
            }
        } catch {
            print("Error:---", error)
        }
    }
    
    @MainActor
    func setInitialValueIsCommentLike(userID: Int?) async {
        do {
            if let userID = userID {
                let setResetCommentLikeResult = try await networkManager.setResetCommentLike(commentID: String(comment.id), userID: userID)
                switch setResetCommentLikeResult.result {
                case 0 :
                    error = setResetCommentLikeResult.error ?? ""
                case 2:
                    isCommentLike = true
                default:
                    break
                }
                _ = try await networkManager.setResetCommentLike(commentID: String(comment.id), userID: userID)
            }
        } catch {
            print("Error:---", error)
        }
    }
}
