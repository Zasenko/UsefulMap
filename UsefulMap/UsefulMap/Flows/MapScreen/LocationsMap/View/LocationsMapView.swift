//
//  LocationMapView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import SwiftUI

struct LocationsMapView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: LocationsMapViewModel
    @ObservedObject var locationRequestviewModel: LocationRequestViewModel
    
    //MARK: - Private properties
        
    init(networkManager: NetworkManager, userViewModel: UserViewModel, locationRequestviewModel: LocationRequestViewModel) {
        _viewModel = StateObject(wrappedValue: LocationsMapViewModel(networkManager: networkManager, userViewModel: userViewModel))
        self.locationRequestviewModel = locationRequestviewModel
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(locations: $viewModel.filteredPlaces, userCoordinates: $locationRequestviewModel.userLocation, celectedLocation: $viewModel.celectedLocation)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        if viewModel.placeCategories.count > 1 {
                            SortingMenu(placeCategories: $viewModel.placeCategories, selectedCategory: $viewModel.selectedCategory, filteredPlaces: $viewModel.filteredPlaces, locations: $viewModel.locations)
                        }
                        Spacer()
                    }
                    Spacer()
                    if viewModel.celectedLocation != nil {
                        NavigationLink {
                            PlaceView(viewModel: PlaceViewModel(networkManager: viewModel.networkManager, userViewModel: viewModel.userViewModel, place: $viewModel.celectedLocation.placeToNonOptional()))
                        } label: {
                            PlaceMapItemView(place: $viewModel.celectedLocation.placeToNonOptional())
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                        }
                    }
                }//-VStack
                .padding(.horizontal)
                if viewModel.isLocationFound == false {
                    ZStack {
                        Color.black.opacity(0.9)
                        VStack {
                            Text("К сожалению, мы ничего не нашли рядом с вами.")
                                .foregroundColor(.white)
                                .padding()
                                .multilineTextAlignment(.center)
                            Button {
                                locationRequestviewModel.authorizationStatus = .denied
                            } label: {
                                Text("Перейти к каталогу")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.green)
                                    .clipShape(Capsule())
                            }
                        }
                    }//-ZStack
                    .ignoresSafeArea()
                }
            }//-ZStack
            .onChange(of: locationRequestviewModel.userLocation) { newLocation in
                guard let userLocation = newLocation else { return }
                locationRequestviewModel.locationManager.stopUpdatingLocation()
                Task {
                    await viewModel.fetchPlacesByUserLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                }
            }
        }//-NavigationStack
    }
}
