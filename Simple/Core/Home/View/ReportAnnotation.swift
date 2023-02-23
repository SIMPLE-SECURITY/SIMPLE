//
//  ReportAnnotation.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import MapKit

class ReportAnnotation: MKPointAnnotation {
    var uid: String
    var status: OSReportStatus
    
    init(uid: String, coordinate: CLLocationCoordinate2D, status: OSReportStatus) {
        self.uid = uid
        self.status = status
        
        super.init()
        self.coordinate = coordinate
    }
}
