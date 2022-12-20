//
//  SequenceExtention.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 20.12.22.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
