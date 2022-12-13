//
//  Comments.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import Foundation

typealias Comments = [Comment]

struct Comment: Codable, Identifiable {
    var id: Int
    var text: String
    var userName: String
    var date: String
    var likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case userName = "user_name"
        case date
        case likesCount = "likes_count"
    }
}
