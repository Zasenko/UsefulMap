//
//  PlaceView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import SwiftUI

struct PlaceView: View {
    
    //MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    @Binding var place: DecodedPlace
    
    @State private var isFavorite: Bool = false
    
    //MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                ZStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: place.photo)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
                    HStack {
                        Button {
                        } label: {
                            Text("Позвонить")
                                .foregroundColor(.black)
                                .padding(10)
                                .padding(.horizontal, 10)
                                .background(.gray)
                                .cornerRadius(15)
                        }
                        if let www = place.www, www.isEmpty == false {
                            Button {
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
                Text(place.address)
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .padding(.bottom, 10)
                Text(place.description ?? "")
                    .lineSpacing(5)
                    .font(.callout)
                    .padding(.horizontal)
                Divider()
                CommentsView(comments: $place.comments)
                    .padding()
            }//-VStack
        }//-ScrollView
        .edgesIgnoringSafeArea(.top)
        .task {
            if place.description == nil {
                await fetchPlaceById(placeId: place.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(place.name)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
            }
            ToolbarItem {
                HStack {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    Button {
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }//-body
    
    @MainActor
    func fetchPlaceById(placeId: Int) async {
        do {
            place = try await networkManager.getPlaceInfoById(placeId: placeId)
        } catch {
            debugPrint("Error: ", error)
        }
    }
}
