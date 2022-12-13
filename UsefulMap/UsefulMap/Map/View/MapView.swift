//
//  MapView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    //MARK: Properties
    
    let viewModel = MapViewModel()
    
    @Binding var locations: Places
    @Binding var userCoordinates: CLLocationCoordinate2D?
    @Binding var celectedLocation: Place?
    
    //MARK: - Functions
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.setRegion(viewModel.defaultRegion, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.annotations.count != locations.count + 1 { /// +1 - User location annotation
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(viewModel.getAnnotation(places: locations))
        }
        let region = viewModel.getRegion(userLocation: uiView.userLocation.coordinate, locations: locations, celectedLocation: celectedLocation)//(userLocation: uiView.userLocation.coordinate)
        uiView.setRegion(region, animated: true)
    }
}
