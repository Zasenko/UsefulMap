//
//  Cities.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import Foundation

typealias Cities = [City]

struct City: Codable, Identifiable {
    var id: Int = 0
    var name: String = ""
    var places: DecodedPlaces = []
}
