//
//  ReportDetailsView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/16/23.
//

import SwiftUI
import Firebase

struct ReportDetailsView: View {
    let report: OSReport
    @StateObject var viewModel = OSReportViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(report.reportType.description)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
//            Spacer()
//
//            Text("Details")
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.leading)
//                .padding(.bottom, 8)
            
            List {
                Section {
                    ReportDetailRowView(model: .init(title: "Location", description: report.locationString))
                    
                    ReportDetailRowView(model: .init(title: "Description", description: report.description))
                    
                    ReportDetailRowView(model: .init(title: "Time Reported", description: report.timestamp.dateString()))
                    
                    ReportDetailRowView(model: .init(title: "Status", description: report.status.description))
                    
                    ReportDetailRowView(model: .init(title: "Last Updated", description: report.lastUpdated.dateString()))
                    
                    ReportDetailRowView(model: .init(title: "Updated By", description: report.updaterUsername))
                    
                    ReportDetailRowView(model: .init(title: "Updater Email", description: report.updaterEmail))
                                        
                    ReportDetailRowView(model: .init(title: "Reported By", description: report.reportedByDescription))
                    
                    ReportDetailRowView(model: .init(title: "Reporter Email", description: report.reportedByDescriptionEmail))
                } header: {
                    Text("Details")
                }
            }
            
            let userName = authViewModel.currentUser?.fullname ?? "n/a"
            let userIsPolice = userName.contains("👮‍♂️")
            let updaterName = report.updaterUsername
            let reportInvolvesPolice = updaterName.contains("👮‍♂️") // police-affiliated reports can only be edited by polices
            
            if viewModel.isEligibleToUpdateReport(self.report) {
                HStack(spacing: 12) {
                    if (userIsPolice) {
                        Button {
                            viewModel.updateReportStatus(.resolved, report: report)
                        } label: {
                            Text("RESOLVE")
                                .fontWeight(.semibold)
                                .frame(width: (UIScreen.main.bounds.width / 3) - 20, height: 50)
                                .frame(maxWidth: 218.3)
                                .background(Color(.systemGreen))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            viewModel.updateReportStatus(.removed, report: report)
                        } label: {
                            Text("DELETE")
                                .fontWeight(.semibold)
                                .frame(width: (UIScreen.main.bounds.width / 3) - 20, height: 50)
                                .frame(maxWidth: 218.3)
                                .background(Color(.systemBlue))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            viewModel.updateReportStatus(.confirmed, report: report)
                        } label: {
                            Text("ALERT")
                                .fontWeight(.semibold)
                                .frame(width: (UIScreen.main.bounds.width / 3) - 20, height: 50)
                                .frame(maxWidth: 218.3)
                                .background(Color(.systemRed))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        if (reportInvolvesPolice) {
                            Text("This report can only be moderated by polices now.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                                .padding(.top, 32)
                                .padding(.bottom, 32)
                        } else { // when both sides are not polices
                            if report.status == .confirmed {
                                Button {
                                    viewModel.updateReportStatus(.resolved, report: report)
                                } label: {
                                    Text("RESOLVE")
                                        .fontWeight(.semibold)
                                        
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                        .frame(maxWidth: 675)
        //                                .frame(maxWidth: 600)
        //                                .frame(height: 44)
                                        .background(Color(.systemGreen))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            
                            if report.status == .resolved {
                                Button {
                                    viewModel.updateReportStatus(.confirmed, report: report)
                                } label: {
                                    Text("ALERT")
                                        .fontWeight(.semibold)
                                        
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                        .frame(maxWidth: 675)
        //                                .frame(maxWidth: 600)
        //                                .frame(height: 44)
                                        .background(Color(.systemRed))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            
                            if report.status == .unconfirmed {
                                Button {
                                    viewModel.updateReportStatus(.resolved, report: report)
                                } label: {
                                    Text("RESOLVE")
                                        .fontWeight(.semibold)
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 25, height: 50)
                                        .frame(maxWidth: 332.5)
                                        .background(Color(.systemGreen))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button {
                                    viewModel.updateReportStatus(.confirmed, report: report)
                                } label: {
                                    Text("ALERT")
                                        .fontWeight(.semibold)
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 25, height: 50)
                                        .frame(maxWidth: 332.5)
                                        .background(Color(.systemRed))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 24)
            } else {
                Text("You are too far away from this incident to provide an update. If it's safe, please move closer to either resolve this issue or confirm the threat.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 32)
            }
        }
        .alert(isPresented: $viewModel.showTimeRestrictionForUpdateAlert, content: {
            Alert(title: Text("Hold Up"), message:
                    Text("To prevent spamming, we place a 3 minute hold on updating reports. Please try again later."))
        })
        .onReceive(viewModel.$didCompleteReportUpdate, perform: { success in
            if success {
                dismiss()
            }
        })
        .ignoresSafeArea()
        .frame(maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

struct ReportDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportDetailsView(report: .init(
            id: NSUUID().uuidString,
            geopoint: GeoPoint(latitude: 37.385, longitude: -122.1),
            reportType: .fire,
            description: "Nearby the street",
            ownerUid: "123",
            ownerUsername: "ashin2022",
            ownerEmail: "ashin2022@gmail.com",
            timestamp: Timestamp(),
            lastUpdated: Timestamp(),
            updaterUsername: "Charles Shin",
            updaterEmail: "cshin12@jhu.edu",
            isAnonymous: true,
            geohash: "9q9hrh5sdd",
            locationString: "1 Hacker Way, Cupertino CA",
            status: .confirmed
        ))
    }
}
