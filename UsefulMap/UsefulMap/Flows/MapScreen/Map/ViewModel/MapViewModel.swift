//
//  MapViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 13.12.22.
//

import MapKit

class MapViewModel {
    
    //MARK: - Properties
    
    let defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(), latitudinalMeters: 5000, longitudinalMeters: 5000)
}

extension MapViewModel {
    
    //MARK: - Functions
    
    func getAnnotation(places: Places) -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        for i in places {
            switch i.type {
            case .bar:
                annotations.append(CustomAnnotation(coordinate: i.coordinate, type: .bar))
            case .restaurant:
                annotations.append(CustomAnnotation(coordinate: i.coordinate, type: .restaurant))
            case .cafe:
                annotations.append(CustomAnnotation(coordinate: i.coordinate, type: .cafe))
            case .club:
                annotations.append(CustomAnnotation(coordinate: i.coordinate, type: .club))
            }
        }
        return annotations
    }
    
    func getRegion(userLocation: CLLocationCoordinate2D, locations: Places, celectedLocation: Place?) -> MKCoordinateRegion {
        var mapLocations: [CLLocationCoordinate2D] = [userLocation]
        
        guard let celectedLocationCoordinate = celectedLocation?.coordinate else {
            if locations.isEmpty {
                return MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            } else {
                for i in locations {
                    mapLocations.append(i.coordinate)
                }
                return regionThatFitsTo(coordinates: mapLocations)
            }
        }
        mapLocations.append(celectedLocationCoordinate)
        return regionThatFitsTo(coordinates: mapLocations)
    }
    
    //MARK: - Private Functions
    
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
