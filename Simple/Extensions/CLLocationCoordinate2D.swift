//
//  CLLocationCoordinate2D.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/19/23.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
