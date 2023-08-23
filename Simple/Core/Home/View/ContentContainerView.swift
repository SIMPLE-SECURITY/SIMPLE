//
//  ContentContainerView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import SwiftUI

struct ContentContainerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var emailAuthenticationRequirements = EmailAuthenticationRequirements.shared
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                if emailAuthenticationRequirements.fetchingIsComplete {
                    VStack {
                        switch viewModel.emailVerificationStatus {
                        case .unverified:
                            SendEmailVerificationView()
                        case .emailSent:
                            EmailVerificationView()
                        case .verified:
                            ContentView()
                        }
                    }
                    .transition(.move(edge: .trailing))
                } else {
                    DataLoadingView()
                        .transition(.move(edge: .leading))
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
