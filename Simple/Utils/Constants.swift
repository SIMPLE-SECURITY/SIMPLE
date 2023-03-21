//
//  Constants.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import Firebase
import Foundation

// emails specially allowed to have police account (police email domains are listed in "policeEmailDomains" variable)
let policesData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/polices.json")!)
let polices = try! JSONDecoder().decode([String].self, from: policesData)


// block reporting feature if too far from any local enforcement agencies (App Store protocol)
let policesLocationData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/policesLocation.json")!)
let policesLocation = try! JSONDecoder().decode([[Double]].self, from: policesLocationData)
 

// all officers with these email domains are regarded as police officers
// listed email domains from most dangerous cities + worst cities with mass shootings in the US
// https://theboutiqueadventurer.com/most-dangerous-cities-in-the-united-states/
// https://www.forbes.com/sites/laurabegleybloom/2023/01/31/most-dangerous-cities-in-the-us-crime-in-america/?sh=6ae421674b25
// search more email domains in Google: "neverbounce [city name] police department" (e.g. "neverbounce detroit police department")
let policeEmailDomainsData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/policeEmailDomains.json")!)
let policeEmailDomains = try! JSONDecoder().decode([String].self, from: policeEmailDomainsData)

 
// US universities are only catalogued so far (+ Chadwick community, JHMI)
// Both the police departments AND university domains (public safety officials) should be valid for police accounts
// https://github.com/Hipo/university-domains-list
let institutionalEmailDomainsData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/institutionalEmailDomains.json")!)
let institutionalEmailDomains = try! JSONDecoder().decode([String].self, from: institutionalEmailDomainsData)


private let REF = Firestore.firestore()

let COLLECTION_USERS = REF.collection("users")
let COLLECTION_REPORTS = REF.collection("reports")

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
    ),
]

