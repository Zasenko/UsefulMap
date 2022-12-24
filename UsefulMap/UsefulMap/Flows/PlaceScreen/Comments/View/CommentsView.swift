//
//  CommentsView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 24.11.22.
//

import SwiftUI

struct CommentsView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: CommentsViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @Binding var comments: Comments?
    @Binding var place: Place
    
    @State private var isCommentViewOpen: Bool = false
    @State private var isLiked: Bool = false
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, comments: Binding<Comments?>, place: Binding<Place>) {
        self._viewModel = StateObject(wrappedValue: CommentsViewModel(networkManager: networkManager, userViewModel: userViewModel, place: place))
        self._comments = comments
        self._place = place
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack(alignment: .top) {
                    if let comm = comments, comm.isEmpty == false {
                        Text("Отзывы")
                            .font(.title)
                        Spacer()
                    }
                    if !isCommentViewOpen {
                        Button {
                            withAnimation {
                                isCommentViewOpen.toggle()
                            }
                        } label: {
                            Text("Написать отзыв")
                                .foregroundColor(.white)
                                .padding(10)
                                .padding(.horizontal, 10)
                                .background(.green)
                                .cornerRadius(15)
                                .opacity(viewModel.isUserLeftComment ? 0 : 1)
                        }
                        .disabled(viewModel.isUserLeftComment)
                    }
                }
            }//-HStac
            .padding()
            if isCommentViewOpen {
                addCommentView
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(), value: viewModel.isUserLeftComment)
                    .alert(isPresented: $viewModel.isUserNotLoggedIn, content: {
                        Alert(title: Text("Для размещения отзыва необходимо авторизоваться"),
                              primaryButton: Alert.Button.default(Text("Перейти к авторизации"),
                                                                  action: ({
                            authenticationViewModel.isLocationViewOpen = false
                            isCommentViewOpen.toggle()
                        })),
                              secondaryButton: Alert.Button.cancel(Text("Отмена"),
                                                                   action: ({
                            viewModel.isUserNotLoggedIn = true
                            isCommentViewOpen.toggle()
                        })))
                    })
            }
            ForEach($comments.toNonOptional()) { $comment in
                CommentView(networkManager: viewModel.networkManager,
                            comment: $comment,
                            isUserNotLoggedIn: $viewModel.isUserNotLoggedIn,
                            userID: viewModel.userViewModel.user.id,
                            authenticationViewModel: authenticationViewModel)
                .onAppear(perform: {
                    viewModel.isUserLeftCommentFunc()
                })
                .shadow(radius: 8)
                .padding(.vertical)
            }
        }//-VStack
    }//-body
    
    //MARK: - Views
    
    var addCommentView: some View {
        return VStack {
            HStack {
                Text("Напиши свой отзыв:")
                    .padding(.leading)
                Spacer()
                Button {
                    withAnimation(.spring()){
                        isCommentViewOpen.toggle()
                    }
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.trailing)
                }

            }
            TextEditor(text: $viewModel.newCommentText)
                .padding()
                .background(.ultraThinMaterial)
                .frame(height: 100)
                .cornerRadius(20)
                .scrollContentBackground(.hidden)
            Button {
                Task {
                    guard let userID = viewModel.userViewModel.user.id else {
                        withAnimation {
                            isCommentViewOpen.toggle()
                        }
                        return
                    }
                    await  viewModel.addComment(placeID: place.id, userID: userID)
                    if viewModel.userViewModel.isUserLoggedIn() {
                        isCommentViewOpen.toggle()
                    }
                }
            } label: {
                Text("Добавить")
                    .foregroundColor(.white)
                    .padding(10)
                    .padding(.horizontal, 10)
                    .background(.green)
                    .cornerRadius(15)
            }
            .padding(.bottom, 20)
            Divider()
                .padding(.vertical)
        }
    }
    
}
