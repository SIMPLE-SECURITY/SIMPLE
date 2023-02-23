//
//  GeoPoint.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/23/23.
//

import Firebase
import CoreLocation

extension GeoPoint {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
