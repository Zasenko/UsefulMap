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
    @State var isFirstLunch = true
    @StateObject var viewModel: CommentViewModel
    @State var isLikeButtonPressed = false
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    //MARK: - Private properties
    
//    @State private var isLiked: Bool = false
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, comment: Binding<Comment>, isUserNotLoggedIn: Binding<Bool>, userID:Int?) {
        self._viewModel = StateObject(wrappedValue: CommentViewModel(networkManager: networkManager, comment: comment))
        self._comment = comment
        self._isUserNotLoggedIn = isUserNotLoggedIn
        self.userID = userID
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
                        Image(systemName: viewModel.isCommentLike ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
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
                    Text(String(comment.likesCount))
                        .font(.footnote.bold())
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
                Task {
                    await viewModel.setInitialValueIsCommentLike(userID: userID)
                    isFirstLunch = false
                }
            }
        }
        )
        .padding()
        .background(.gray)
        .cornerRadius(20)
    }
}
