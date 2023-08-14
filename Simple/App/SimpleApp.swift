//
//  SimpleApp.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        EmailAuthenticationRequirements.shared.fetchAllData()
        return true
    }
}

@main
struct SimpleApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var mapViewModel = OSMapViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentContainerView()
                .environmentObject(authViewModel)
                .environmentObject(mapViewModel)
        }
    }
}
