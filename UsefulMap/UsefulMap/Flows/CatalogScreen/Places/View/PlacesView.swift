//
//  PlacesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct PlacesView: View {
    
    //MARK: - Properties
    
    let viewModel: PlacesViewModel
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            List(viewModel.$city.places) { $place in
                NavigationLink {
                    PlaceView(viewModel: PlaceViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, place: $place))
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
                await viewModel.fetchPlacesByCityId()
            }
            .listStyle(.plain)
            .navigationTitle(viewModel.city.name)
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
