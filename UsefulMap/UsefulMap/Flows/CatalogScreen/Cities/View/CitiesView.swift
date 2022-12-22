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
    @Binding var country: Country
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, country: Binding<Country>) {
        viewModel = CitiesViewModel(networkManager: networkManager, userViewModel: userViewModel)
        _country = country
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppImages.mapBackground
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
                List($country.cities) { $city in
                    NavigationLink {
                        PlacesView(viewModel: PlacesViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, city: $city))
                    } label: {
                        Text(city.name)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.clear)
                }
                .task {
                    if country.cities.isEmpty {
                        country.cities = await viewModel.fetchCitiesByCountryId(countryId: country.id)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(country.name)
                .toolbar {
                    ToolbarItem {
                        Button {
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
            }//-ZStack
        }//-NavigationStack
        .tint(.black)
    }//-body
}
