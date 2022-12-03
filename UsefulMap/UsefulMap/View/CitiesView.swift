//
//  CitiesView.swift
//  UsefulMap
//
//  Created by Eduard on 24.11.2022.
//

import SwiftUI

struct CitiesView: View {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    @Binding var country: Country
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("map")
                    .resizable()
                    .blur(radius: 10)
                    .ignoresSafeArea()
                List($country.cities) { $city in
                    NavigationLink {
                        PlacesView(networkManager: networkManager, userViewModel: userViewModel, city: $city)
                    } label: {
                        Text(city.name)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.clear)
                }
                .task {
                    if country.cities.isEmpty {
                        country.cities = await fetchCitiesByCountryId()
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
            }
        }.tint(.black)
    }//-body
    
    @MainActor
    func fetchCitiesByCountryId() async -> Cities {
        do {
            let cities = try await networkManager.getAllCitiesByCountryId(countryId: country.id)
            return cities
        } catch {
            debugPrint("Error: ", error)
            return []
        }
    }
}
