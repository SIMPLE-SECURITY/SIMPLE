//
//  User.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import Foundation
import CoreLocation
import Firebase

struct User: Codable {
    let uid: String
    let fullname: String
    let email: String
    var geopoint: GeoPoint
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
             formatter.style = .abbreviated
             return formatter.string(from: components)
        }
        
        return "N/A"
    }
}
