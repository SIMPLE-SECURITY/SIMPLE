//
//  ReportService.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/24/23.
//

import Firebase

struct ReportService {
    
    // TODO: Move all report API functions to this file
    
    static func deleteReport(_ report: OSReport) async {
        let reportTimestamp = report.lastUpdated.dateValue()
        let diff = Int(Date().timeIntervalSince1970 - reportTimestamp.timeIntervalSince1970)
        let diffInMinutes = diff / 60
        
        if diffInMinutes >= 15 {
            try? await EmailAuthenticationRequirements.shared.COLLECTION_REPORTS.document(report.id).delete()
        }
    }
}
