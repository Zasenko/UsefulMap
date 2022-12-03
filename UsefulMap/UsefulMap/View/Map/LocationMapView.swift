//
//  LocationMapView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import SwiftUI

struct LocationMapView: View {
    
    let networkManager: NetworkManager
    @ObservedObject var locationManager: LocationManager
    @State private var locations: DecodedPlaces = []
    @State private var celectedLocation: Place?
    
    var body: some View {
        ZStack {
            MapView(locations: $locations, userCoordinates: $locationManager.userLocation, celectedLocation: $celectedLocation, annotationOnTap: { place in
                celectedLocation = place
            })
                .ignoresSafeArea()
            VStack {
                Spacer()
                if celectedLocation != nil {
                    VStack {
                        Text(celectedLocation?.name ?? "")
                        Text(celectedLocation?.address ?? "")
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear() {
            
            //TODO: получение локаций после того, как получим положение юзера
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Task {
                    await fetchLocations()
                }
            }
        }
    }
    
    @MainActor
    func fetchLocations() async {
        do {
            locations = try await networkManager.getAllPlacesByUserLocation(latitude: locationManager.userLocation.latitude, longitude: locationManager.userLocation.longitude)
        } catch {
            debugPrint("Error: ", error)
        }
    }
}
