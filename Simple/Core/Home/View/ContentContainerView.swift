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
                    .transition(.move(edge: .leading))
            } else {
                if emailAuthenticationRequirements.fetchingIsComplete {
                    VStack {
                        switch viewModel.emailVerificationStatus {
                        case .unverified:
                            SendEmailVerificationView()
                                .transition(.move(edge: .leading))
                        case .emailSent:
                            EmailVerificationView()
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        case .verified:
                            ContentView()
                                .transition(.move(edge: .trailing))
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
