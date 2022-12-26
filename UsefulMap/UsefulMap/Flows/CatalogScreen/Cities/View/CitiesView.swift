//
//  CitiesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct CitiesView: View {
    
    //MARK: - Properties
    
    let viewModel: CitiesViewModel

    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppImages.mapBackground
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
                List(viewModel.$country.cities) { $city in
                    NavigationLink {
                        PlacesView(viewModel: PlacesViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, city: $city))
                    } label: {
                        Text(city.name)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.clear)
                }
                .task {
                    if viewModel.country.cities.isEmpty {
                        await viewModel.fetchCitiesByCountryId()
                    }
                }
                .listStyle(.plain)
                .navigationTitle(viewModel.country.name)
            }//-ZStack
        }//-NavigationStack
        .tint(.black)
    }//-body
}
