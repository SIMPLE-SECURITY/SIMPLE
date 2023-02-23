//
//  ContentContainerView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import SwiftUI

struct ContentContainerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                switch viewModel.emailVerificationStatus {
                case .unverified:
                    SendEmailVerificationView()
                case .emailSent:
                    EmailVerificationView()
                case .verified:
                    ContentView()
                }
            }
        }
    }
}

struct ContentContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentContainerView()
    }
}
