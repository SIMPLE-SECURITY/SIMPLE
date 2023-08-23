//
//  Constants.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import Firebase
import UIKit
import Foundation
import SwiftUI

class EmailAuthenticationRequirements: ObservableObject {
    
    static let shared = EmailAuthenticationRequirements()
    @Published var fetchingIsComplete = false
    
    init() {}
    
    func fetchAllData() {
        Task(priority: .high) {
            do {
                try await fetchPoliceData()
                try await fetchPoliceLocationData()
                try await fetchPoliceEmailDomainsData()
                try await fetchInstitutionalEmailDomainsData()
                
                withAnimation() {
                    fetchingIsComplete = true
                }
            } catch {
                print("EmailAuthenticationRequirements fetch error: \(error)")
            }
        }
    }
    
    // emails specially allowed to have police account (police email domains are listed in "policesEmailDomains" variable)
    
    private func fetchPoliceData() async throws {
        guard let url = URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/polices.json") else {
            return
        }
        let data = try Data(contentsOf: url)
        polices = try JSONDecoder().decode([String].self, from: data)
    }
    
    private(set) var polices: [String] = []
    
    //let polices =
    //
    //// emails specially allowed to have police account (police email domains are listed in "policesEmailDomains" variable)
    //
    //[
    //    "ashin2022@gmail.com", // personal email. for developer's administrative use
    //    "jjacks48@jhu.edu", // Jarron L Jackson, Baltimore Police Department
    //    "rrule@chadwickschool.org", // Bob Rule, Chadwick School (Palos Verdes)
    //    "thill@chadwickschool.org" // Ted Hill, Chadwick International (South Korea)
    //]
    
    // block reporting feature if too far from any local enforcement agencies (App Store protocol)
    private func fetchPoliceLocationData() async throws {
        guard let url = URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/policesLocation.json") else {
            return
        }
        let data = try Data(contentsOf: url)
        policesLocation = try JSONDecoder().decode([[Double]].self, from: data)
    }
    
    private(set) var policesLocation: [[Double]] = []
    
    // all officers with these email domains are regarded as police officers
    // listed email domains from most dangerous cities + worst cities with mass shootings in the US
    // https://theboutiqueadventurer.com/most-dangerous-cities-in-the-united-states/
    // https://www.forbes.com/sites/laurabegleybloom/2023/01/31/most-dangerous-cities-in-the-us-crime-in-america/?sh=6ae421674b25
    // search more email domains in Google: "neverbounce [city name] police department" (e.g. "neverbounce detroit police department")
    private func fetchPoliceEmailDomainsData() async throws {
        guard let url = URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/policesEmailDomains.json") else {
            return
        }
        let data = try Data(contentsOf: url)
        policesEmailDomains = try JSONDecoder().decode([String].self, from: data)
    }
    
    private(set) var policesEmailDomains: [String] = []
    
    // US universities are only catalogued so far (+ Chadwick community, JHMI)
    // Both the police departments AND university domains (public safety officials) should be valid for police accounts
    // https://github.com/Hipo/university-domains-list
    private func fetchInstitutionalEmailDomainsData() async throws {
        guard let url = URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/institutionalEmailDomains.json") else {
            return
        }
        let data = try Data(contentsOf: url)
        institutionalEmailDomains = try JSONDecoder().decode([String].self, from: data)
    }
    
    private(set) var institutionalEmailDomains: [String] = []
    
    private let REF = Firestore.firestore()
    
    let COLLECTION_USERS = Firestore.firestore().collection("users")
    let COLLECTION_REPORTS = Firestore.firestore().collection("reports")
    
    let MOCK_REPORTS: [OSReport] = [
        .init(
            id: NSUUID().uuidString,
            geopoint: GeoPoint(latitude: 37.385, longitude: -122.1),
            reportType: .fire,
            description: "",
            ownerUid: "123",
            ownerUsername: "ashin2022",
            ownerEmail: "ashin2022@gmail.com",
            timestamp: Timestamp(),
            lastUpdated: Timestamp(),
            updaterUsername: "Charles Shin",
            updaterEmail: "cshin12@jhu.edu",
            isAnonymous: true,
            showToPolicesOnly: false,
            geohash: "9q9hrh5sdd",
            locationString: "1 Hacker Way, Cupertino CA",
            status: .unconfirmed
        ),
        .init(
            id: NSUUID().uuidString,
            geopoint: GeoPoint(latitude: 37.334, longitude: -122.009),
            reportType: .fire,
            description: "",
            ownerUid: "123",
            ownerUsername: "ashin2022",
            ownerEmail: "ashin2022@gmail.com",
            timestamp: Timestamp(),
            lastUpdated: Timestamp(),
            updaterUsername: "Charles Shin",
            updaterEmail: "cshin12@jhu.edu",
            isAnonymous: true,
            showToPolicesOnly: true,
            geohash: "9q9hrh5sdd",
            locationString: "1 Hacker Way, Cupertino CA",
            status: .unconfirmed
        ),
        .init(
            id: NSUUID().uuidString,
            geopoint: GeoPoint(latitude: 37.325, longitude: -122.009),
            reportType: .fire,
            description: "",
            ownerUid: "123",
            ownerUsername: "ashin2022",
            ownerEmail: "ashin2022@gmail.com",
            timestamp: Timestamp(),
            lastUpdated: Timestamp(),
            updaterUsername: "Charles Shin",
            updaterEmail: "cshin12@jhu.edu",
            isAnonymous: true,
            showToPolicesOnly: false,
            geohash: "9q9hrh5sdd",
            locationString: "1 Hacker Way, Cupertino CA",
            status: .unconfirmed
        ),
        .init(
            id: NSUUID().uuidString,
            geopoint: GeoPoint(latitude: 36, longitude: -122.009),
            reportType: .fire,
            description: "",
            ownerUid: "123",
            ownerUsername: "ashin2022",
            ownerEmail: "ashin2022@gmail.com",
            timestamp: Timestamp(),
            lastUpdated: Timestamp(),
            updaterUsername: "Charles Shin",
            updaterEmail: "cshin12@jhu.edu",
            isAnonymous: true,
            showToPolicesOnly: false,
            geohash: "9q9hrh5sdd",
            locationString: "1 Hacker Way, Cupertino CA",
            status: .unconfirmed
        )
    ]
    
}
