//
//  OSReportViewModel.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/16/23.
//

import Firebase
import FirebaseFirestoreSwift
import GeoFireUtils
import SwiftUI

@MainActor
class OSReportViewModel: NSObject, ObservableObject {
    @Published var didUploadReport = false
    @Published var didCompleteReportUpdate = false
    @Published var addressString = ""
    @Published var showErrorAlert = false
    @Published var showTimeRestrictionAlert = false
    @Published var showTimeRestrictionForUpdateAlert = false
    @Published var showReportDistanceAlert = false
    @Published var results = [MKLocalSearchCompletion]()
    
    private var currentLocationAddressString = ""
    private var remainingTimeForNextReportUpload = 0.0
    private let timeLimitInSeconds: Double = 20 * 60 // 20 minutes, polices under same restriction in case they get hacked
    private let timeLimitForUpdateInSeconds: Double = 3 * 60 // 3 minutes, for same reason
    private let searchCompleter = MKLocalSearchCompleter()
    private var userLocation = LocationManager.shared.userLocation
    private let minimumDistanceToUpdateReportInMeters: Double = 300
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
        Task {
            try await getPlacemark()
        }
    }
    
    // MARK: - Reports
    
    func isEligibleToUpdateReport(_ report: OSReport) -> Bool {
        guard let userLocation = userLocation?.toCLLocation() else { return false }
        let reportLocation = report.geopoint.toCLLocation()
        let distance = userLocation.distance(from: reportLocation)

        return distance <= minimumDistanceToUpdateReportInMeters
    }
    
    var isEligibleToUpdateReport: Bool {
        guard let lastUploadDate = UserDefaults.standard.value(forKey: "lastUploadTime") as? Date else { return true }
        let timeSinceLastUploadInSeconds = Date().timeIntervalSince(lastUploadDate)
        return timeLimitForUpdateInSeconds < Double(timeSinceLastUploadInSeconds)
    }
    
    var isEligibleToCreateReport: Bool {
        guard let lastUploadDate = UserDefaults.standard.value(forKey: "lastUploadTime") as? Date else { return true }
        let timeSinceLastUploadInSeconds = Date().timeIntervalSince(lastUploadDate)
        return timeLimitInSeconds < Double(timeSinceLastUploadInSeconds)

    }
    
    func uploadReport(type: OSReportType, description: String, isAnonymous: Bool, policeReportAlert: Bool) async throws {
        guard isEligibleToCreateReport else {
            self.showErrorAlert = true
            self.showTimeRestrictionAlert = true
            return
        }
        self.showTimeRestrictionAlert = false
        
        guard !self.showReportDistanceAlert else {
            self.showErrorAlert = true
            return
        }
        self.showErrorAlert = false
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userLocation = userLocation else { return }
        let geopoint = GeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let geohash = GFUtils.geoHash(forLocation: userLocation)
        let uploadTime = Timestamp()
        let ref = Firestore.firestore().collection("reports").document()
        guard let fullname = UserDefaults.standard.value(forKey: "fullname") as? String else { return }
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        
        var status: OSReportStatus = .unconfirmed
        if (fullname.contains("👮‍♂️")) {
            status = policeReportAlert ? .confirmed : .resolved
        }
        
        let report = OSReport(
            id: ref.documentID,
            geopoint: geopoint,
            reportType: type,
            description: description,
            ownerUid: uid,
            ownerUsername: fullname,
            ownerEmail: email,
            timestamp: uploadTime,
            lastUpdated: uploadTime,
            updaterUsername: fullname,
            updaterEmail: email,
            isAnonymous: isAnonymous,
            geohash: geohash,
            locationString: addressString,
            status: status
        )
        
        guard let encodedReport = try? Firestore.Encoder().encode(report) else { return }
        
        do {
            try await COLLECTION_REPORTS.document(ref.documentID).setData(encodedReport)
            self.didUploadReport = true
            UserDefaults.standard.set(Timestamp().dateValue(), forKey: "lastUploadTime")
        } catch {
            print("DEBUG: Failed to upload report with error: \(error)")
        }
    }
    
    func resolveReport(_ report: OSReport, _ name: String, _ email: String) async {
        try? await COLLECTION_REPORTS.document(report.id).updateData([
            "status": OSReportStatus.resolved.rawValue,
            "lastUpdated": Timestamp(),
            "updaterUsername": name,
            "updaterEmail": email
        ])
        
        didCompleteReportUpdate = true 
    }
    
    func alert(_ report: OSReport, _ name: String, _ email: String) async {
        try? await COLLECTION_REPORTS.document(report.id).updateData([
            "status": OSReportStatus.confirmed.rawValue,
            "lastUpdated": Timestamp(),
            "updaterUsername": name,
            "updaterEmail": email
        ])
        
        didCompleteReportUpdate = true
    }
    
    func removeReport(_ report: OSReport, _ name: String, _ email: String) async {
        try? await COLLECTION_REPORTS.document(report.id).updateData([
            "status": OSReportStatus.removed.rawValue,
            "lastUpdated": Timestamp(),
            "updaterUsername": name,
            "updaterEmail": email
        ])
        
        didCompleteReportUpdate = true
    }
    
    func updateReportStatus(_ status: OSReportStatus, report: OSReport) {
        guard isEligibleToUpdateReport else {
            self.showTimeRestrictionForUpdateAlert = true
            return
        }
        guard let fullname = UserDefaults.standard.value(forKey: "fullname") as? String else { return }
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        Task {
            switch status {
            case .unconfirmed:
                break
            case .confirmed:
                await alert(report, fullname, email)
            case .resolved:
                await resolveReport(report, fullname, email)
            case .removed:
                await removeReport(report, fullname, email)
            }
        }
        
        self.showTimeRestrictionForUpdateAlert = false
        UserDefaults.standard.set(Timestamp().dateValue(), forKey: "lastUploadTime")
    }
    
    // MARK: - Location Helpers
    
    func getPlacemark() async throws {
        guard let location = LocationManager.shared.userLocation else { return }
        
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
            guard let placemark = placemarks.first else { return }
            self.addressString = addressFromPlacemark(placemark)
            self.currentLocationAddressString = self.addressString
        } catch {
            print("DEBUG: Failed to reverse geocode location \(error.localizedDescription)")
        }
    }
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
             result += thoroughfare
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            result += " \(subThoroughfare)"
        }
        
        if let subadministrativeArea = placemark.subAdministrativeArea {
            result += ", \(subadministrativeArea)"
        }
        
        return result
    }
    
    func updateCurrentLocationAddressString() {
        self.addressString = currentLocationAddressString
        self.userLocation = LocationManager.shared.userLocation
        self.showErrorAlert = false
        self.showReportDistanceAlert = false
    }
    
    func updateCustomLocationAddressString(_ localSearchCompletion: MKLocalSearchCompletion) {
        let subtitle = localSearchCompletion.subtitle.replacingOccurrences(of: ", United States", with: "")
        self.addressString = localSearchCompletion.title + " " + subtitle
        
        Task {
            try await locationSearch(forLocalSearchCompletion: localSearchCompletion)
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion) async throws {
        guard let userLocation = LocationManager.shared.userLocation else { return }
        
        do {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
            let search = MKLocalSearch(request: searchRequest)
            let response = try await search.start()
            guard let item = response.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            let distanceFromUserLocation = userLocation.toCLLocation().distance(from: coordinate.toCLLocation())

            guard distanceFromUserLocation <= 100 else {
                self.showErrorAlert = true
                self.showReportDistanceAlert = true 
                return
            }
            self.showErrorAlert = false
            self.showReportDistanceAlert = false
            self.userLocation = coordinate
        } catch {
            print("DEBUG: Failed to generate location data with error: \(error.localizedDescription)")
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension OSReportViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results.filter({ !$0.subtitle.isEmpty && $0.subtitle != "Search Nearby" })
    }
}

