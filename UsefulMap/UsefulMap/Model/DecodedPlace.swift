//
//  DecodedPlace.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 03.12.22.
//

import Foundation

typealias DecodedPlaces = [DecodedPlace]

struct DecodedPlace: Codable, Identifiable {
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
}
