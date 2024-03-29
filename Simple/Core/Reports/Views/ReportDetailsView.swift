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
            
            let userName = authViewModel.currentUser?.fullname ?? "N/A"
            let userIsPolice = userName.contains("👮‍♂️")
            let updaterName = report.updaterUsername
            let reportInvolvesPolice = updaterName.contains("👮‍♂️") // police-affiliated reports should only be edited by polices
            
            List {
                Section {
                    ReportDetailRowView(model: .init(title: "Location", description: report.locationString))
                    
                    ReportDetailRowView(model: .init(title: "Description", description: report.description))
                    
                    ReportDetailRowView(model: .init(title: "Time Reported", description: report.timestamp.dateString()))
                    
                    ReportDetailRowView(model: .init(title: "Status", description: report.status.description))
                    
                    ReportDetailRowView(model: .init(title: "Last Updated", description: report.lastUpdated.dateString()))
                    
                    ReportDetailRowView(model: .init(title: "Updated By", description: report.updaterUsername))
                    
                    ReportDetailRowView(model: .init(title: "Updater Email", description: report.updaterEmail))
                                        
                    ReportDetailRowView(model: .init(title: "Reported By", description: report.ownerUsername))
                    
                    ReportDetailRowView(model: .init(title: "Reporter Email", description: report.ownerEmail))
                    
                    if (userIsPolice) {
                        ReportDetailRowView(model: .init(title: "Who can See This Report", description: report.showToPolicesOnlyDescription))
                    }
                } header: {
                    Text("Details")
                }
            }
            
            if viewModel.isEligibleToUpdateReport(self.report) {
                HStack(spacing: 12) {
                    if (userIsPolice) {
                        Button {
                            viewModel.updateReportStatus(.resolved, report: report)
                        } label: {
                            Text("RESOLVE")
                                .textModifier(type: "Button", split: 3, color: Color(.systemGreen))
                        }
                        
                        Button {
                            viewModel.updateReportStatus(.removed, report: report)
                        } label: {
                            Text("DELETE")
                                .textModifier(type: "Button", split: 3, color: Color(.systemBlue))
                        }
                        
                        Button {
                            viewModel.updateReportStatus(.confirmed, report: report)
                        } label: {
                            Text("ALERT")
                                .textModifier(type: "Button", split: 3, color: Color(.systemRed))
                        }
                    } else {
                        if reportInvolvesPolice {
                            Text("This report can only be moderated by polices now.")
                                .textModifier(type: "Text")
                        } else { // when both sides are not polices
                            if report.status == .confirmed {
                                Button {
                                    viewModel.updateReportStatus(.resolved, report: report)
                                } label: {
                                    Text("RESOLVE")
                                        .textModifier(type: "Button", split: 1, color: Color(.systemGreen))
                                }
                            }
                            
                            if report.status == .resolved {
                                Button {
                                    viewModel.updateReportStatus(.confirmed, report: report)
                                } label: {
                                    Text("ALERT")
                                        .textModifier(type: "Button", split: 1, color: Color(.systemRed))
                                }
                            }
                            
                            if report.status == .unconfirmed {
                                Button {
                                    viewModel.updateReportStatus(.resolved, report: report)
                                } label: {
                                    Text("RESOLVE")
                                        .textModifier(type: "Button", split: 2, color: Color(.systemGreen))
                                }
                                
                                Button {
                                    viewModel.updateReportStatus(.confirmed, report: report)
                                } label: {
                                    Text("ALERT")
                                        .textModifier(type: "Button", split: 2, color: Color(.systemRed))
                                }
                            }
                        }
                    }
                }
                .padding() // needed to prevent button from skretching full width in iphones
                .padding(.bottom, 24)
            } else {
                Text("You are too far away from this incident to provide an update. If it's safe, please move closer to either resolve this issue or confirm the threat.")
                    .textModifier(type: "Text")
            }
        }
        .alert(isPresented: $viewModel.showTimeRestrictionForUpdateAlert) {
            if (viewModel.timeLimitForUpdateInSeconds < 60) {
                return Alert(title: Text("Updating Limit"), message:
                        Text("To prevent spamming, we place a \(Int(viewModel.timeLimitForUpdateInSeconds)) second hold on updating reports. Please try again later.")) // police
            } else {
                return Alert(title: Text("Updating Limit"), message:
                        Text("To prevent spamming, we place a \(Int(viewModel.timeLimitForUpdateInSeconds / 60)) minute hold on updating reports. Please try again later."))
            }
        }
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

struct TextModifier: ViewModifier {
    var type: String
    var split : Int
    var color: Color

    func body(content: Content) -> some View {
        switch type {
        case "Button":
            switch split {
            case 3:
                content
                    .fontWeight(.semibold)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 20, height: 50)
                    .frame(maxWidth: 218.3)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            case 2:
                content
                    .fontWeight(.semibold)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 25, height: 50)
                    .frame(maxWidth: 332.5)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            case 1:
                content
                    .fontWeight(.semibold)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                    .frame(maxWidth: 675)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            default:
                content
            }
        case "Text":
            content
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 32)
        default:
            content
        }
    }
}

extension Text {
    func textModifier(type: String, split: Int = 1, color: Color = Color(.systemBlue)) -> some View {
        self.modifier(TextModifier(type: type, split: split, color: color))
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
            showToPolicesOnly: false,
            geohash: "9q9hrh5sdd",
            locationString: "1 Hacker Way, Cupertino CA",
            status: .confirmed
        ))
    }
}
