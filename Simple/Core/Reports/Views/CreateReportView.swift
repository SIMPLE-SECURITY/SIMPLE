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
    @State private var shouldRemainAnonymous = false
    @State private var selectedLocationType: OSReportLocationType = .current
    @State private var showLocationSearch = false
    @StateObject private var viewModel = OSReportViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Report")
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
                                    .foregroundColor(Color(.systemBlue))
                                
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
                                                ? Color(.systemBlue)
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
                        Toggle(isOn: $shouldRemainAnonymous) {
                            Text("Remain Anonymous")
                        }
                    }
                }
                
                Button {
                    Task {
                        try await viewModel.uploadReport(
                            type: OSReportType(rawValue: selectedReportType) ?? .medicalEmergency,
                            description: description,
                            isAnonymous: shouldRemainAnonymous
                        )
                    }
                } label: {
                    Text("Send Report")
                        .fontWeight(.semibold)
                        
                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                        .frame(maxWidth: 675)
//                                .frame(maxWidth: 600)
//                                .frame(height: 44)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
            }
            .navigationDestination(isPresented: $showLocationSearch, destination: {
                LocationSearchView(viewModel: viewModel, selectedLocation: .constant(""))
            })
            .alert(isPresented: $viewModel.showErrorAlert) {
                if $viewModel.showTimeRestrictionAlert.wrappedValue {
                    return Alert(title: Text("Error"), message:
                                    Text("To prevent spamming, we place a 20 minute hold on reports. Please try again later."))
                }
                if $viewModel.showReportDistanceAlert.wrappedValue {
                    return Alert(title: Text("Error"), message:
                                    Text("You are too far away from this location to create a report."))
                }
                return Alert(title: Text("Error"), message:
                                Text("An error occurred while processing your report. Please try again later."))
            }
            .onReceive(viewModel.$didUploadReport, perform: { success in
                if success {
                    dismiss()
                }
            })
            .onAppear {
                showLocationSearch = false
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct CreateReportView_Previews: PreviewProvider {
    static var previews: some View {
        CreateReportView()
    }
}
