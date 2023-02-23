//
//  Date.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import Firebase
import Foundation

extension Date {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM dd"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
}

extension Timestamp {
    func dateString() -> String {
        return dateValue().dateString()
    }
}
