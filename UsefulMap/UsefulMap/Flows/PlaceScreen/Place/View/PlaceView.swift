//
//  PlaceView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import SwiftUI

struct PlaceView: View {
    
    //MARK: - Properties
    
    let viewModel: PlaceViewModel

    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                ZStack(alignment: .bottom) {
                    CachedImageView(viewModel: CachedImageViewModel(url: viewModel.place.photo))
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
                    HStack {
                        Button {
                        action: do {
                            guard let url = URL(string: "tel://" + String(viewModel.place.phone ?? 12345)) else { return }
                            UIApplication.shared.open(url)
                            print(url)
                        }
                        } label: {
                            Text("Позвонить")
                                .foregroundColor(.black)
                                .padding(10)
                                .padding(.horizontal, 10)
                                .background(.gray)
                                .cornerRadius(15)
                        }
                        if let www = viewModel.place.www, www.isEmpty == false {
                            Button {
                            action: do {
                                openURL(URL(string: viewModel.place.www ?? "google.com")!)
                            }
                            } label: {
                                Text("Перейти на сайт")
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .padding(.horizontal, 10)
                                    .background(.gray)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                Text(viewModel.place.address)
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .padding(.bottom, 10)
                Text(viewModel.place.description ?? "")
                    .lineSpacing(5)
                    .font(.callout)
                    .padding(.horizontal)
                Divider()
                CommentsView(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, comments: viewModel.$place.comments, place: viewModel.$place)
                    .padding()
            }//-VStack
            .background(LinearGradient(colors: [.white, .white, .teal, .blue], startPoint: .top, endPoint: .bottom))
        }//-ScrollView
        .ignoresSafeArea()
        .task {
            await viewModel.fetchPlaceById()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            ToolbarItem(placement: .principal) {
                Text(viewModel.place.name)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
            }
            ToolbarItem {
                if viewModel.userViewModel.isUserLoggedIn() {
                    Button {
                        Task {
                            await viewModel.likePlace()
                        }
                    } label: {
                        Image(systemName: viewModel.place.isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(viewModel.place.isLiked ? .red : .white)
                            .frame(width: 28, height: 28)
                            .bold()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbarColorScheme(.dark, for: .navigationBar)
    }//-body
}
