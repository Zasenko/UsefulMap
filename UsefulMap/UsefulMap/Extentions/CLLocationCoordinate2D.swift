//
//  CLLocationCoordinate2D.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 08.12.22.
//

import CoreLocation

extension CLLocationCoordinate2D : Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}
