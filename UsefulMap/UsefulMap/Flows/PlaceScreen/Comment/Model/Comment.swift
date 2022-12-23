//
//  Comment.swift
//  UsefulMap
//
//  Created by Eduard on 19.12.2022.
//

import SwiftUI

struct Comment: Codable, Identifiable {
    var id: Int
    var text: String
    var userName: String
    var date: String
    var likesCount: Int
    var isCommentLikeCurrentUser = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case userName = "user_name"
        case date
        case likesCount = "likes_count"
    }
}
