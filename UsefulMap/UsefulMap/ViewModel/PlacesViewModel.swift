//
//  PlacesViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import Foundation

//class PlacesViewModel: ObservableObject {
//    
//    //MARK: - Properties
//    
//    @Published var countries: Countries = []
//    let networkManager = NetworkManager()
//    
//    //MARK: - Functions
//    
//    @MainActor
//    func fetchCountries() async {
//        do {
//            countries = try await networkManager.getAllCountries()
//        } catch {
//            debugPrint("Error: ", error)
//        }
//    }
//    
//    @MainActor
//    func fetchCitiesByCountryId(countryId: Int) async -> Cities {
//        do {
//            let cities = try await networkManager.getAllCitiesByCountryId(countryId: countryId)
//            return cities
//        } catch {
//            debugPrint("Error: ", error)
//            return []
//        }
//    }
//    
//    @MainActor
//    func fetchPlacesByCityId(cityId: Int) async -> Places {
//        do {
//            let places = try await networkManager.getAllPlacesByCityId(cityId: cityId)
//            return places
//        } catch {
//            debugPrint("Error: ", error)
//            return []
//        }
//    }  
//}
