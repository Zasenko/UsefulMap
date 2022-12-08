//
//  LocationMapView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import SwiftUI

struct LocationMapView: View {
    
    //MARK: - Properties
    
    @ObservedObject var locationManager: LocationManager
    
    //MARK: - Private properties
    
    @State private var celectedLocation: Place?
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            MapView(locations: $locationManager.locations, userCoordinates: $locationManager.userLocation, celectedLocation: $celectedLocation)
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
    }
}
