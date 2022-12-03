//
//  PlacesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct PlacesView: View {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    @Binding var city: City
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            List($city.places) { $place in
                NavigationLink {
                    PlaceView(networkManager: networkManager, userViewModel: userViewModel, place: $place)
                } label: {
                    PlaceItemView(place: place)
                }
                .listRowBackground(Color.clear)
            }
            .background(
                Image("map")
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
            )
            .task {
                if city.places.isEmpty {
                    city.places = await fetchPlacesByCityId(cityId: city.id)
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
    
    @MainActor
    func fetchPlacesByCityId(cityId: Int) async -> DecodedPlaces {
        do {
            let places = try await networkManager.getAllPlacesByCityId(cityId: city.id)
            return places
        } catch {
            debugPrint("Error: ", error)
            return []
        }
    }
}
