//
//  ResetPasswordView.swift
//  SIMPLE
//
//  Created by Charles Shin on 2/7/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 75)
            Spacer()
                .frame(height: 75)
            
            Image(colorScheme == .dark ? "reset-dark" : "reset")
                .resizable()
                .frame(width: 140, height: 140*2500/2429)
                .padding(.vertical, 32)
            
            
            OSInputField(text: $email,
                         title: "Email Address",
                         placeholder: "Enter the email for your account")
            .padding()
            .autocapitalization(.none)
            .frame(maxWidth: 500)
                        
            Button {
                viewModel.sendResetPasswordLink(toEmail: email)
                dismiss()
            } label: {
                HStack {
                    Text("SEND RESET LINK")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .frame(width: 200, height: 50)
//                .frame(width: UIScreen.main.bounds.width - 165, height: 50)
            }
            .background(Color(colorScheme == .dark ? .white : .black))
//            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding()
            
//            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")

                    Text("Back to Login")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }
            .frame(alignment: .bottom)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
