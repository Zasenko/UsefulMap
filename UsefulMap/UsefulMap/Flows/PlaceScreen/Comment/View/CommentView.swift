//
//  CommentView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 24.11.22.
//

import SwiftUI

struct CommentView: View {
    
    //MARK: - Properties

    @Binding var comment: Comment
    @Binding var isUserNotLoggedIn: Bool
    let userID: Int?
    var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var viewModel: CommentViewModel
    @State var isLikeButtonPressed = false
   
    
    //MARK: - Private properties
    
    @State private var isFirstLunch = true
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager,
         comment: Binding<Comment>,
         isUserNotLoggedIn: Binding<Bool>,
         userID:Int?,
         authenticationViewModel: AuthenticationViewModel) {
        self._viewModel = StateObject(wrappedValue: CommentViewModel(networkManager: networkManager, comment: comment, authenticationViewModel: authenticationViewModel))
        self._comment = comment
        self._isUserNotLoggedIn = isUserNotLoggedIn
        self.userID = userID
        self.authenticationViewModel = authenticationViewModel
    }
    
    //MARK: - Body
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.userName)
                        .bold()
                        .padding(.vertical, 4)
                    Spacer()
                    Button {
                        if !isUserNotLoggedIn {
                            Task {
                                await viewModel.setResetCommentLike(userID: userID)
                            }
                        }
                        isLikeButtonPressed.toggle()
                    } label: {
                        HStack {
                            Image(systemName: (viewModel.isCommentLike || comment.isCommentLikeCurrentUser) ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(comment.isCommentLikeCurrentUser ? .blue : .gray)
                            Text(String(comment.likesCount))
                                .font(.footnote.bold())
                                .foregroundColor(comment.isCommentLikeCurrentUser ? .blue : .gray)
                        }
                    }
                    .alert(isPresented: Binding(get: {isUserNotLoggedIn && isLikeButtonPressed}, set: {_ in }) , content: {
                        Alert(title: Text("Чтобы лайкнуть отзыв необходимо авторизоваться"),
                              primaryButton: Alert.Button.default(Text("Перейти к авторизации"),
                                                                  action: ({
                                                                            authenticationViewModel.isLocationViewOpen = false
                                                                            isLikeButtonPressed.toggle()
                                                                            
                                                                    })),
                              secondaryButton: Alert.Button.cancel(Text("Отмена"),
                                                                   action: ({
                                                                            isUserNotLoggedIn = true
                                                                            isLikeButtonPressed.toggle()
                                                                    })))
                    })
                }//-HStack
                Text(comment.text)
                    .font(.subheadline)
                Text(comment.date)
                    .font(.footnote.bold())
                    .padding(.vertical, 4)
            }//-VStack
            Spacer()
        }//-HStack
        .onAppear(perform: {
            if isFirstLunch {
                viewModel.commentViewLikesInitialization()
                isFirstLunch = false
            }
        }
        )
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
    }
}

