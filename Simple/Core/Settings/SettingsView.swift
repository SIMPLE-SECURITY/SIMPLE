//
//  SettingsView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/16/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var notificationsEnabled = false
    var body: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.currentUser {
                let userIsPolice = (user.fullname).contains("👮‍♂️")
                
                HStack(spacing: 15) {
                    Text(userIsPolice ? "Police" : user.initials)
                        .font(userIsPolice ? .title2 : .title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(Color(userIsPolice ? .systemGray : .systemGray3))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullname)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                            .autocapitalization(.none)
                        
                        Text(user.email)
                            .font(.footnote)
                            .accentColor(.gray)
                            .autocapitalization(.none)
                    }
                }
                .padding()
            }
            
            List {
                Section("General") {
//                    Toggle(isOn: $notificationsEnabled) { }
//                    .tint(Color(.systemBlue))
                    
                    HStack {
                        SettingsRowView(imageName: "gear.circle",
                                        title: "Version",
                                        tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        SettingsRowView(imageName: "bell.circle.fill",
                                        title: "Notifications",
                                        tintColor: Color(.systemBlue))
                        
                        Spacer()
                        
                        Text("Coming soon")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Simple") {
                    Button {
                        if let url = URL(string: "https://simplesecure.substack.com") {
                            openURL(url)
                        }
                    } label: {
                        SettingsRowView(imageName: "bookmark.circle.fill",
                                        title: "Newsletter",
                                        tintColor: Color(.systemYellow))
                    }
                    
                    Button {
                        if let url = URL(string: "https://www.simple-secure.org/mission") {
                            openURL(url)
                        }
                    } label: {
                        SettingsRowView(imageName: "newspaper.circle.fill",
                                        title: "Our Mission",
                                        tintColor: Color(.systemGreen))
                    }
                    
                    Button {
                        if let url = URL(string: "https://linktr.ee/simplesecure") {
                            openURL(url)
                        }
                    } label: {
                        SettingsRowView(imageName: "arrow.right.circle.fill",
                                        title: "About Us",
                                        tintColor: Color(.systemPurple))
                    }
                }
                
                if let user = viewModel.currentUser {
                    let userIsPolice = (user.fullname).contains("👮‍♂️")
                    
                    if userIsPolice {
                        Section("Police") {
                            HStack {
                                Button {
                                    if let url = URL(string: "mailto:charlesshin@simple-secure.org") {
                                        openURL(url)
                                    }
                                }
                            label: {
                                SettingsRowView(imageName: "envelope.badge.shield.half.filled.fill",
                                                title: "Request Support",
                                                tintColor: Color(.systemIndigo))
                            }
                            }
                        }
                    }
                }
                
                Section("Developers") {
                    HStack {
                        Button {
                            if let url = URL(string: "https://github.com/tlsgusdn1107/SIMPLE") {
                                openURL(url)
                            }
                        }
                    label: {
                        SettingsRowView(imageName: "square.stack.3d.up",
                                        title: "Source Code",
                                        tintColor: Color(.systemTeal))
                    }
//
//                        Spacer()
//
//                        Text("March release")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
                    }
                }
                
                Section("Account") {
                    if let user = viewModel.currentUser {
                        let userIsPolice = (user.fullname).contains("👮‍♂️")
                        Button {
                            Task {
                                await viewModel.reqeustChange()
                            }
                        } label: {
                            SettingsRowView(imageName: "arrow.left.arrow.right.circle.fill",
                                            title: userIsPolice ? "Switch to Basic Account" : "Switch to Police Account",
                                            tintColor: Color(.systemRed))
                        }
                    }
                    
                    Button {
                        viewModel.signout()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Sign Out",
                                        tintColor: Color(.systemRed))
                    }
                    
                    Button {
                        viewModel.deleteConfirmation()
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: Color(.systemRed))
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .alert(viewModel.settingMessage?.title ?? "", isPresented: $viewModel.showSettingAlert, actions: {
            switch viewModel.settingMessage {
            case .confirmingDelete:
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                        viewModel.deleteConfirmation2()
                    }
                }
            case .confirmingDelete2:
                TextField("", text: $viewModel.deleteAccountConfirmationText)
                Button("Cancel", role: .cancel) {
                    viewModel.deleteAccountConfirmationText = ""
                }
                Button("Delete", role: .destructive) {
                    Task {
                        try await viewModel.deleteAccount()
                    }
                }
            default:
                Button("ok") {}
            }
        }, message: {
            Text(viewModel.settingMessage?.description ?? "")
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
