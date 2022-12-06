//
//  Place.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 03.12.22.
//

import Foundation
import MapKit

typealias Places = [Place]

class Place: NSObject, MKAnnotation {
    let id: Int
    let name: String
    let type: PlaceType
    let address: String
    let coordinate: CLLocationCoordinate2D
    var photo: String //TODO: UIImage
    var distance: Float?
    //TODO: доделдать модель
//    var country: String?
//    var city: String?
//    var description: String?
//    var www: String?
//    var phone: Int?
//    var comments: Comments?
    
    init(id: Int, name: String, type: PlaceType, address: String, coordinate: CLLocationCoordinate2D, photo: String, distance: Float? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.address = address
        self.coordinate = coordinate
        self.photo = photo
        self.distance = distance
    }
}
