//
//  СountriesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct СountriesView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: СountriesViewModel
    
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppImages.mapBackground
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
                List ($viewModel.countries) { $country in
                    NavigationLink {
                        CitiesView(viewModel: CitiesViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, country: $country))
                    } label: {
                        Text(country.name)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .task {
                    if viewModel.countries.isEmpty {
                        await viewModel.fetchCountries()
                    }
                }
                .navigationTitle("Страны")
            }//-ZStack
        }//-NavigationStack
        .tint(.black)
    }//-body
}
