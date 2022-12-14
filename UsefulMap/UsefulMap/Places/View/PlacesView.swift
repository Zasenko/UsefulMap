//
//  PlacesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct PlacesView: View {
    
    //MARK: - Properties
    
    let viewMode: PlacesViewModel
    @Binding var city: City
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, city: Binding<City>) {
        self.viewMode = PlacesViewModel(networkManager: networkManager, userViewModel: userViewModel)
        self._city = city
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            List($city.places) { $place in
                NavigationLink {
                    PlaceView(networkManager: viewMode.networkManager, userViewModel: viewMode.userViewModel, place: $place)
                } label: {
                    PlaceItemView(place: place)
                }
                .listRowBackground(Color.clear)
            }
            .background(
                AppImages.mapBackground
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
            )
            .task {
                if city.places.isEmpty {
                    city.places = await viewMode.fetchPlacesByCityId(cityId: city.id)
                }
            }
            .listStyle(.plain)
            .navigationTitle(city.name)
            .toolbar {
                ToolbarItem {
                    Button {
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }//-NavigationStack
        .tint(.black)
    }
}
