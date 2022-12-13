//
//  СountriesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct СountriesView: View {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    //MARK: - Private properties
    
    @State private var countries: Countries = []
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppImages.mapBackground
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
                List ($countries) { $country in
                    NavigationLink {
                        CitiesView(networkManager: networkManager, userViewModel: userViewModel, country: $country)
                    } label: {
                        Text(country.name)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .task {
                    if countries.isEmpty {
                        await fetchCountries()
                    }
                }
                .navigationTitle("Страны")
                .toolbar {
                    ToolbarItem {
                        Button {
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.black)
                        }
                    }
                }
            }//-ZStack
        }//-NavigationStack
        .tint(.black)
    }//-body
    
    //MARK: - Functions
    
    @MainActor
    func fetchCountries() async {
        do {
            countries = try await networkManager.getAllCountries()
        } catch {
            debugPrint("Error: ", error)
        }
    }
}
