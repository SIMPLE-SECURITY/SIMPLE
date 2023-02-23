//
//  OSLocationReportType.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/16/23.
//

import Foundation

enum OSReportLocationType: Int, CaseIterable, Identifiable {
    case current
    case custom
    
    var id: Int {
        return self.rawValue
    }
    
    var imageName: String {
        switch self {
        case .custom:
            return "mappin.circle"
        case .current:
            return "location.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .custom:
            return "Custom"
        case .current:
            return "Current"
        }
    }
}
