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
