//
//  EmailVerificationView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 75)
            
            Image("sent-verify")
                .resizable()
                .frame(width: 140, height: 140*2500/2401)
                .foregroundColor(Color(.systemBlue))
                .padding(.top, 56)

            
            Text("Verification sent")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 12)
                .padding(.vertical, 16)
            
            Text("Once you receive the email, please click on the verification link. Then return to the app and click below to continue to the app.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(width: 260)
                .lineSpacing(6)
            
            Button {
                Task {
                    await viewModel.updateEmailVerificationStatus()
                }
            } label: {
                HStack {
                    Text("CONTINUE TO APP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: 165, height: 70)
//                .frame(width: UIScreen.main.bounds.width - 165, height: 50)
            }
            .background(Color(.black))
//            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.vertical, 24)
            
            Button {
                Task { try await viewModel.sendVerificationEmail() }
            } label: {
                HStack(spacing: 4) {
                    Text("Didn't receive the email?")
                    
                    Text("Click to resend")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }

            Spacer()
            
            Button {
                viewModel.signout()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.left")
                    Text("Return to Login page")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }
            .frame(alignment: .bottom)
        }
        .alert(isPresented: $viewModel.showAuthAlert, content: {
            Alert(title: Text("Error"), message: Text(viewModel.authError?.description ?? AuthenticationError.unknown.description))
        })
        
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView()
    }
}

