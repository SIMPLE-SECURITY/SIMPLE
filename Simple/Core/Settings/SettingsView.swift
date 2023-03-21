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
                HStack (spacing: 15) {
                    Text((user.fullname).contains("👮‍♂️") ? "Police" : user.initials)
                        .font(polices.contains(user.email) ? .title2 : .title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(Color(polices.contains(user.email) ? .systemGray : .systemGray3))
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
                    if (user.fullname).contains("👮‍♂️") {
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
                    Button {
                        viewModel.signout()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Sign Out",
                                        tintColor: Color(.systemRed))
                    }
                    
                    Button {
                        Task {
                            try await viewModel.deleteAccount()
                        }
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: Color(.systemRed))
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .alert(isPresented: $viewModel.deleteAlert) {
            Alert(
                title: Text("Authentication Required"),
                message: Text("Deleting your account requires recent authentication. Log in again before retrying it.")
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
