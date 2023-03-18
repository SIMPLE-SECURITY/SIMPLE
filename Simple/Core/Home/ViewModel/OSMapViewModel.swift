//
//  OSMapViewModel.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/15/23.
//

import Firebase
import FirebaseFirestoreSwift
import MapKit
import GeoFireUtils

class OSMapViewModel: ObservableObject {
    @Published var reports = [OSReport]()
    @Published var userRegion: MKCoordinateRegion?
    @Published var showAlert = false
    var shouldUpdateReports = false
    private let radius: Double = 50 * 1000 // report fetching radius in meters
    var didExecuteFetchReports = false
    var listeners = [ListenerRegistration]()
    
    func reportIsFresh(_ report: OSReport) -> Bool {
        let reportTimestamp = report.lastUpdated.dateValue()
        let diffInSeconds = Int(Date().timeIntervalSince1970 - reportTimestamp.timeIntervalSince1970)
        return diffInSeconds <= report.status.expirationTimeInSeconds
    }
    
    func updateMapRegionToUserLocation() {
        guard let userLocation = LocationManager.shared.userLocation else { return }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: userLocation.latitude,
                                           longitude: userLocation.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        self.userRegion = region
    }
    
    @MainActor
    func fetchReports() {
        guard let userLocation = LocationManager.shared.userLocation else { return }
        guard let fullname = UserDefaults.standard.value(forKey: "fullname") as? String else { return }
        let queryBounds = GFUtils.queryBounds(forLocation: userLocation, withRadius: radius)
                
        let queries = queryBounds.map { bound -> Query in
            return COLLECTION_REPORTS
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        for query in queries {
            let listener = query.addSnapshotListener { snapshot, _ in
                guard let changes = snapshot?.documentChanges else { return }
                
                for change in changes {
                    if change.type == .added {
                        guard let report = try? change.document.data(as: OSReport.self) else { return }
                        if !fullname.contains("👮‍♂️") {
                            guard (report.isAnonymous == false) else { continue } // if user is not police, non-anonymous reports are only displayed (anonymous reports are sent to polices for review)
                        }
                        
                        if self.reportIsFresh(report) {
                            self.reports.append(report)
                        } else {
                            self.deleteReport(report)
                        }
                        
                        self.shouldUpdateReports = true
                        
                    } else if change.type == .modified {
                        guard let report = try? change.document.data(as: OSReport.self) else { return }
                        if !fullname.contains("👮‍♂️") {
                            guard (report.isAnonymous == false) else { continue }
                        }

                        guard let index = self.reports.firstIndex(where: { $0.id == report.id }) else { return }
                        
                        if self.reportIsFresh(report) {
                            self.reports[index] = report
                        }
                        
                        self.shouldUpdateReports = true
                    }
                }
            }
            
            listeners.append(listener)
        }
    }
    
    
    @MainActor
    func refreshReports() {
        self.userRegion = nil
        didExecuteFetchReports = false
        self.reports.removeAll()
        removeDatabaseListeners()
        fetchReports()
    }
    
    @MainActor
    func deleteReport(_ report: OSReport) {
        Task {
            try? await COLLECTION_REPORTS.document(report.id).delete()
            guard let index = reports.firstIndex(where: {$0.id == report.id }) else { return }
            reports.remove(at: index)
            self.shouldUpdateReports = true
        }
    }
    
    func removeDatabaseListeners() {
        listeners.forEach({ $0.remove() })
        listeners.removeAll()
    }
}
