//
//  BindingPropertyExtentions.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 30.11.22.
//

import SwiftUI

extension Binding where Value == Comments? {
    func toNonOptional() -> Binding<Comments> {
        return Binding<Comments>(
            get: {
                return self.wrappedValue ?? []
            },
            set: {
                self.wrappedValue = $0
            }
        )
    }
}

extension Binding where Value == Place? {
    func placeToNonOptional() -> Binding<Place> {
        return Binding<Place>(
            get: {
                return self.wrappedValue ?? Place(id: 0, name: "", type: .restaurant, address: "", latitude: 0.0, longitude: 0.0, photo: "Place")
            },
            set: {
                self.wrappedValue = $0
            }
        )
    }
}
