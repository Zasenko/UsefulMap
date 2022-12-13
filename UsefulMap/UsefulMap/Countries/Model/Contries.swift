//
//  Contries.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 23.11.22.
//

import Foundation

typealias Countries = [Country]

struct Country: Codable, Identifiable {
    var id: Int = 0
    var name: String = ""
    var cities: Cities = []
}
