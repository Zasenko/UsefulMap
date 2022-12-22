//
//  LikeResult.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.12.22.
//

import Foundation

enum LikeResultType: Int, Codable {
    case error = 0
    case liked = 1
    case disliked = 2
}

struct LikeResult: Codable {
    let result: LikeResultType
    let error: String?
}
