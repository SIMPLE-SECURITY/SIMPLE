//
//  OSReport.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/15/23.
//

import Firebase
import Foundation

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

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
    let updaterUsername: String
    let updaterEmail: String
    let isAnonymous: Bool
    let geohash: String
    let locationString: String
    var status: OSReportStatus
    
    var reportedByDescription: String {
        return isAnonymous ? "Anonymous" : ownerUsername
    }
    var reportedByDescriptionEmail: String {
        var anonymousEmail = ownerEmail
        if let index = ownerEmail.index(of: "@") {
            let domain = String(ownerEmail[index...])
            anonymousEmail = "*****" + String(domain) // redact specifics, but identify organization
        }
        return isAnonymous ? anonymousEmail : ownerEmail
    }
}

enum OSReportStatus: Int, Codable {
    case unconfirmed
    case confirmed
    case resolved
    case removed
    
    var description: String {
        switch self {
        case .unconfirmed:
            return "Unconfirmed"
        case .confirmed:
            return "**ALERT**"
        case .resolved:
            return "Resolved"
        case .removed:
            return "Removed"
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
        case .removed:
            return "xmark.circle.fill"
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
        case .removed:
            return .black
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
        case .removed:
            return 0 // instant removal
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
