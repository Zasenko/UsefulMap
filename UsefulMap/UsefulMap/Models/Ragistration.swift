//
//  Ragistration.swift
//  UsefulMap
//
//  Created by Eduard on 04.12.2022.
//

import Foundation

struct RegistrationResult: Codable {
    var result: Int = 0
    var error: String? = nil
    var user: User? = nil
}

