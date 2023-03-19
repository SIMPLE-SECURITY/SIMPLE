//
//  ContentView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMenuOption: MenuOptions?
    @State private var selectedReport: OSReport?
    @EnvironmentObject var viewModel: OSMapViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        let userName = authViewModel.currentUser?.fullname ?? "N/A"
        let reportIcon = userName.contains("👮‍♂️") ? "airplayaudio.badge.exclamationmark" : "exclamationmark.bubble.fill"
        ZStack(alignment: .bottomTrailing) {
            OSMapView(selectedReport: $selectedReport)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                MapViewActionButton(action: {
                    viewModel.refreshReports()
                },
                                    imageName: "arrow.counterclockwise",
                                    tintColor: Color(.systemPink))
                
                MapViewActionButton(action: {
                    viewModel.updateMapRegionToUserLocation()
                },
                                    imageName: "location.north.fill",
                                    tintColor: Color(.systemBlue))
                MapViewActionButton(action: {
                    selectedMenuOption = .settings
                },
                                    imageName: "gear",
                                    tintColor: Color(.systemPurple))
                
                MapViewActionButton(action: {
                    selectedMenuOption = .report
                },
                                    imageName: reportIcon,
                                    tintColor: Color(.red))
            }
            .sheet(item: $selectedMenuOption) { option in
                switch option {
                case .report:
                    CreateReportView()
                        .presentationDetents([.height(550)])
                case .settings:
                    SettingsView()
                        .presentationDetents([.large])
                        .environmentObject(authViewModel)
                }
            }
            .padding(32)
        }
        .background(content: {
            EmptyView()
                .sheet(item: $selectedReport, content: { report in
                    ReportDetailsView(report: report)
                        .presentationDetents([.height(580)])
                        .onDisappear {
                            self.selectedReport = nil
                        }
                })
        })
        .onAppear {
            viewModel.fetchReports()
//            Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
//                viewModel.refreshReports()
//            } recenters screen for unknown reason. check OSMapViewModel.swift
        }
        
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
