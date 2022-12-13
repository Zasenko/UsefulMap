//
//  MapViewCoordinator.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 08.12.22.
//

import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    
    //MARK: - Properties
    
    var parent: MapView
    
    //MARK: - Initialization
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    //MARK: - Functions
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else {
            return nil
        }
        let annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: customAnnotation.identifier)
        annotationView.canShowCallout = false
        annotationView.displayPriority = .required
        
        switch customAnnotation.type {
        case .bar:
            annotationView.markerTintColor = .blue
            annotationView.glyphImage = AppImages.iconBar
        case .restaurant:
            annotationView.markerTintColor = .red
            annotationView.glyphImage = AppImages.iconRestaurant
        case .cafe:
            annotationView.markerTintColor = .orange
            annotationView.glyphImage = AppImages.iconCafe
        case .club:
            annotationView.markerTintColor = .systemCyan
            annotationView.glyphImage = AppImages.iconClub
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if annotation is CustomAnnotation {
            parent.celectedLocation = parent.locations.first(where: { $0.coordinate == annotation.coordinate })
            let sourceCoordinate = mapView.userLocation.coordinate
            let destinationCoordinate = annotation.coordinate

            directions(from: sourceCoordinate, to: destinationCoordinate).calculate { response, error in
                guard error == nil, let route = response?.routes.first else {
                    return
                }
                mapView.addOverlay(route.polyline)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        parent.celectedLocation = nil
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
}

//MARK: - Private functions

extension MapViewCoordinator {
    private func directions(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> MKDirections {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        return MKDirections(request: request)
    }
}
