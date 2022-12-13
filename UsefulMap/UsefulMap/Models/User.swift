//
//  User.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import Foundation

struct LoginResult: Codable {
    var result: Int = 0
    var error: String? = nil
    var user: User? = nil
}

struct User: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case likedComments = "liked_comments"
        case savedPlaces = "saved_places"
    }
    
    var id: Int? = nil
    var name: String? = nil
    var likedComments: [UserComment]? = nil
    var savedPlaces: [UserPlace]? = nil
}

struct UserComment: Codable, Identifiable {
    var id: Int
}

struct UserPlace: Codable, Identifiable {
    var id: Int
}
