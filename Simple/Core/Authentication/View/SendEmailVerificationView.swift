//
//  SendEmailVerificationView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import SwiftUI
import SFSafeSymbols

struct SendEmailVerificationView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
//            Spacer()
//                .frame(height: 75)
            
            Image(colorScheme == .dark ? "send-verify-dark" : "send-verify")
                .resizable()
                .frame(width: 140, height: 140*2500/2151)
                .foregroundColor(Color(.systemBlue))
                .padding(.top, 56)
            
            Text("Verify your email")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 12)
                .padding(.vertical, 16)
            
            Text("To finish your sign-up, we require email verification. Please click the button below to receive your verification email.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(width: 260)
                .lineSpacing(6)
            
            Button {
                Task {
                    try await viewModel.sendVerificationEmail()
                }
            } label: {
                HStack {
                    Text("SEND EMAIL")
                        .fontWeight(.semibold)
                    Image(systemSymbol: SFSymbol.arrowRight)
                }
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .frame(width: 160, height: 50)
//                .frame(width: UIScreen.main.bounds.width - 190, height: 50)
            }
            .background(Color(colorScheme == .dark ? .white : .black))
//            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.vertical, 24)
            
            Button {
                viewModel.signout()
            } label: {
                HStack(spacing: 4) {
                    Image(systemSymbol: SFSymbol.arrowLeft)
                    Text("Return to Login page")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }
            .frame(alignment: .bottom)
//            Spacer()
            
        }
        .alert(isPresented: $viewModel.showAuthAlert, content: {
            Alert(title: Text(viewModel.authError?.title ?? AuthenticationError.unknown.title), message: Text(viewModel.authError?.description ?? AuthenticationError.unknown.description))
        })
    }
}

struct SendEmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        SendEmailVerificationView()
    }
}
