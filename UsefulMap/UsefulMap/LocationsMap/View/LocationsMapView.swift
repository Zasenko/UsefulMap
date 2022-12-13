//
//  LocationMapView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import SwiftUI

struct LocationsMapView: View {
    
    //MARK: - Properties
    
    @ObservedObject var locationManager: LocationManager
    let userViewModel: UserViewModel
    //MARK: - Private properties
    
    @State private var celectedLocation: Place?
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(locations: $locationManager.locations, userCoordinates: $locationManager.userLocation, celectedLocation: $celectedLocation)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    if let location = celectedLocation {
                        NavigationLink {
                            PlaceView(networkManager: locationManager.networkManager, userViewModel: userViewModel, place: $celectedLocation.placeToNonOptional())
                        } label: {
                            PlaceItemView(place: location)
                                .background(Color.gray)
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                    }
                    
                }//-VStack
            }//-ZStack
        }//-NavigationStack
    }
}
