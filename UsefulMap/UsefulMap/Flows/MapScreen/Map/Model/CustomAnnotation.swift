//
//  CustomAnnotation.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 08.12.22.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    //MARK: - Properties
    
    public let identifier = "CustomAnnotation"
    
    let coordinate: CLLocationCoordinate2D
    let type: PlaceType
    
    //MARK: - Initialization
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinate
        self.type = type
    }
}
