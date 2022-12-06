//
//  MapView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    //MARK: Properties
    
    @Binding  var locations: DecodedPlaces
    @Binding var userCoordinates: CLLocationCoordinate2D
    @Binding var celectedLocation: Place?
    
    var annotationOnTap: (_ place: Place?) -> Void
    
    //MARK: - Functions
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        let region = MKCoordinateRegion(center: userCoordinates, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        var annotations: [MKAnnotation] = []
        var mapLocations: [CLLocationCoordinate2D] = [userCoordinates]
        
        //TODO модель!
        for i in locations {
            let coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
            mapLocations.append(coordinate)
            let sourceAnnotation = Place(id: i.id, name: i.name, type: i.type, address: i.address, coordinate: coordinate, photo: i.photo)
            annotations.append(sourceAnnotation)
        }
        uiView.addAnnotations(annotations)
        
        var region: MKCoordinateRegion
        if celectedLocation != nil {
            guard let celectedCoordinates = celectedLocation?.coordinate else {return}
            region = regionThatFitsTo(coordinates: [celectedCoordinates, userCoordinates])
        } else {
            region = regionThatFitsTo(coordinates: mapLocations)
        }
        uiView.setRegion(region, animated: true)
    }
    
    private func regionThatFitsTo(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        for coordinate in coordinates {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
        }
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4
        return region
    }
    
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    deinit {
        print("deinit: MapCoordinator")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let mapAnnotation = annotation as? Place else {
            return
        }
        
        let sourceCoordinate = mapView.userLocation.coordinate
        let destinationCoordinate = annotation.coordinate
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            guard let route = response?.routes.first,
                  error != nil else {
                return
            }
            mapView.addOverlay(route.polyline)
        }
        parent.annotationOnTap(mapAnnotation)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        parent.annotationOnTap(nil)
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
}
