//
//  Constants.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import Firebase

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
        isAnonymous: true,
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
        isAnonymous: true,
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
        isAnonymous: true,
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
        isAnonymous: true,
        geohash: "9q9hrh5sdd",
        locationString: "1 Hacker Way, Cupertino CA",
        status: .unconfirmed
    ),
]

