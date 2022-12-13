//
//  Place.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 03.12.22.
//

import Foundation
import CoreLocation

typealias Places = [Place]

struct Place: Codable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case id,
             name,
             type,
             address,
             latitude,
             longitude,
             photo,
             distance,
             country,
             city,
             description,
             www,
             phone,
             comments
    }
    
    var id: Int
    var name: String
    var type: PlaceType
    var address: String
    var latitude: Double
    var longitude: Double
    var photo: String
    var distance: Float?
    var country: String?
    var city: String?
    var description: String?
    var www: String?
    var phone: Int?
    var comments: Comments?
    var isLiked: Bool = false
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
