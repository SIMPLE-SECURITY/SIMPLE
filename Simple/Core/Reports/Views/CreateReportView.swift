//
//  CreateReportView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/15/23.
//

import SwiftUI

struct CreateReportView: View {
    @State private var selectedReportType = OSReportType.medicalEmergency.rawValue
    @State private var description = ""
    @State private var shouldBeAlerted = true
    @State private var shouldRemainAnonymous = false
    @State private var selectedLocationType: OSReportLocationType = .current
    @State private var showLocationSearch = false
    @State private var showInfo = false
    @State private var policeShowInfo = false
    @State private var onlyPolicesCanSeeReport = false
    @State private var onlyPolicesCanSeeReportShowInfo = false
    @StateObject private var viewModel = OSReportViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let userName = authViewModel.currentUser?.fullname ?? "N/A"
        NavigationStack {
            VStack { // no (spacing: 0) so as to scroll contents w/o cutting out title
                Text(userName.contains("👮‍♂️") ? "Police Report" : "Create Report")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                
                Form {
                    Section {
                        Picker(selection: $selectedReportType) {
                            ForEach(OSReportType.allCases) { type in
                                Text(type.description)
                            }
                        } label: {
                            Text("Report Type")
                        }
                        
                        TextField("Description", text: $description, axis: .vertical)
                            .onReceive(description.publisher.collect()) {
                                self.description = String($0.prefix(120))
                            }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "location.square.fill")
                                    .imageScale(.medium)
                                    .font(.title)
                                    .foregroundColor(Color(userName.contains("👮‍♂️") ? .systemRed : .systemBlue))
                                
                                Text("Location")
                            }
                            
                            HStack(spacing: 64) {
                                Spacer()
                                
                                ForEach(OSReportLocationType.allCases) { type in
                                    VStack {
                                        Image(systemName: type.imageName)
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                            .foregroundColor(
                                                type == selectedLocationType
                                                ? Color(userName.contains("👮‍♂️") ? .systemRed : .systemBlue)
                                                : Color(.systemGray3)
                                            )
                                        
                                        Text(type.title)
                                            .font(.footnote)
                                            .frame(width: 48)
                                    }
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedLocationType = type
                                            
                                            if type == .current {
                                                viewModel.updateCurrentLocationAddressString()
                                            } else {
                                                showLocationSearch.toggle()
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                            
                            Text(viewModel.addressString)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 8)
                        }
                    }
                    
                    Section {
                        if (userName.contains("👮‍♂️")) {
                            Toggle(isOn: $shouldBeAlerted) {
                                HStack {
                                    Text("Resolved or Alert")
                                    Button(action: {
                                        self.policeShowInfo.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color(.systemRed))
                                    }
                                }
                            }
                            .toggleStyle(CheckmarkToggleStyle())
                            .alert(isPresented: $policeShowInfo) {
                                Alert(
                                    title: Text("Resolved or Alert"),
                                    message: Text("Police reports can be in one of two states: resolved or alerted. Resolved reports are typically used for general notifications, whereas alerted reports are reserved for emergency situations."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            
                            Toggle(isOn: $onlyPolicesCanSeeReport) {
                                HStack {
                                    Text("Show to Polices Only")
                                    Button(action: {
                                        self.onlyPolicesCanSeeReportShowInfo.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color(.systemRed))
                                    }
                                }
                            }
                            .alert(isPresented: $onlyPolicesCanSeeReportShowInfo) {
                                Alert(
                                    title: Text("Show to Polices Only"),
                                    message: Text("Police can share reports only with other police, or they can choose to share them with the public instantly."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            .tint(Color(.systemRed))
                        } else {
                            Toggle(isOn: $shouldRemainAnonymous) {
                                HStack {
                                    Text("Remain Anonymous")
                                    Button(action: {
                                        self.showInfo.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                    }
                                }
                            }
                            .alert(isPresented: $showInfo) {
                                Alert(
                                    title: Text("Remain Anonymous"),
                                    message: Text("Anonymous reports are first shared only with the police for verification purposes. Non-anonymous reports, on the other hand, are immediately broadcast to those in your vicinity."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                    }
                }
                
                Button {
                    Task {
                        try await viewModel.uploadReport(
                            type: OSReportType(rawValue: selectedReportType) ?? .medicalEmergency,
                            description: description,
                            isAnonymous: shouldRemainAnonymous,
                            policeIssuesReportAsAlert: shouldBeAlerted,
                            showToPolicesOnly: onlyPolicesCanSeeReport
                        )
                    }
                } label: {
                    Text(userName.contains("👮‍♂️") ? "Broadcast Report" : "Send Report")
                        .fontWeight(.semibold)
                        
                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                        .frame(maxWidth: 675)
//                                .frame(maxWidth: 600)
//                                .frame(height: 44)
                        .background(Color(userName.contains("👮‍♂️") ? .systemRed : .systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding() // needed to prevent button from skretching full width in iphones
//                .padding(.bottom, -10) // redacted because it doesn't fit for ipad size
            }
            .navigationDestination(isPresented: $showLocationSearch, destination: {
                LocationSearchView(viewModel: viewModel, selectedLocation: .constant(""))
            })
            .alert(isPresented: $viewModel.showErrorAlert) {
                if $viewModel.showLocalEnforcementDistanceAlert.wrappedValue {
                    return Alert(title: Text("Report Unavailable"), message:
                                    Text("You are too far away from the nearest local enforcement agency to create a report."))
                }
                if $viewModel.showTimeRestrictionAlert.wrappedValue {
                    if (viewModel.timeLimitInSeconds < 60) {
                        return Alert(title: Text("Reporting Limit"), message: Text("To prevent spamming, we place a \(Int(viewModel.timeLimitInSeconds)) second hold on reports. Please try again later.")) // police
                    } else {
                        return Alert(title: Text("Reporting Limit"), message: Text("To prevent spamming, we place a \(Int(viewModel.timeLimitInSeconds / 60)) minute hold on reports. Please try again later."))
                    }
                }
                if $viewModel.showReportDistanceAlert.wrappedValue {
                    return Alert(title: Text("Location Unavailable"), message:
                                    Text("You are too far away from the selected location to create a report."))
                }
                return Alert(title: Text("Report Failed"), message:
                                Text("An error occurred while processing your report. Please try again later."))
            }
            .onReceive(viewModel.$didUploadReport, perform: { success in
                if success {
                    dismiss()
                }
            })
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                showLocationSearch = false
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .red : .green)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "exclamationmark" : "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ? .red : .green)
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.125))
                        
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
    
}

struct CreateReportView_Previews: PreviewProvider {
    static var previews: some View {
        CreateReportView()
    }
}
