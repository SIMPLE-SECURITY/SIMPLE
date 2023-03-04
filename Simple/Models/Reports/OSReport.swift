//
//  OSReport.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/15/23.
//

import Firebase

struct OSReport: Identifiable, Codable, Equatable {
    let id: String
    let geopoint: GeoPoint
    let reportType: OSReportType
    let description: String
    let ownerUid: String
    let ownerUsername: String
    let ownerEmail: String
    let timestamp: Timestamp
    let lastUpdated: Timestamp
    let isAnonymous: Bool
    let geohash: String
    let locationString: String
    var status: OSReportStatus
    
    var reportedByDescription: String {
        return isAnonymous ? "Anonymous" : ownerUsername
    }
}

enum OSReportStatus: Int, Codable {
    case unconfirmed
    case confirmed
    case resolved
    
    var description: String {
        switch self {
        case .unconfirmed:
            return "Unconfirmed"
        case .confirmed:
            return "**ALERT**"
        case .resolved:
            return "Resolved"
        }
    }
    
    var imageName: String {
        switch self {
        case .unconfirmed:
            return "questionmark.circle.fill"
        case .confirmed:
            return "exclamationmark.triangle.fill"
        case .resolved:
            return "checkmark.circle.fill"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .unconfirmed:
            return .systemBlue
        case .confirmed:
            return .systemRed
        case .resolved:
            return .systemGreen
        }
    }
    
    var expirationTimeInSeconds: Int {
        switch self {
        case .confirmed:
            return 60 * 60 // 60 minutes
        case .resolved:
            return 15 * 60 // 15 minutes
        case .unconfirmed:
            return 30 * 60 // 30 minutes
        }
    }
}

enum OSReportType: Int, CaseIterable, Codable, Identifiable {
    case medicalEmergency
    case automotiveIncident
    case fire
    case gasLeak
    case personInjured
    case severeWeather
    case indecentExposure
    case suspiciousPerson
    case robbery
    case suspiciousPackage
    case civilUnrest
    case activeShooter
    case bombThreat
    case otherThreat
    
    var id: Int {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .medicalEmergency: return "Medical Emergency"
        case .automotiveIncident: return "Automotive Incident"
        case .fire: return "Fire"
        case .gasLeak: return "Gas Leak"
        case .personInjured: return "Person Injured"
        case .severeWeather: return "Severe Weather"
        case .indecentExposure: return "Indecent Exposure"
        case .suspiciousPerson: return "Suspicious Person"
        case .robbery: return "Robbery"
        case .suspiciousPackage: return "Suspicious Package"
        case .civilUnrest: return "Civil Unrest"
        case .activeShooter: return "Active Shooter"
        case .bombThreat: return "Bomb Threat"
        case .otherThreat: return "Other"
        }
    }
}
