//
//  LoginView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Spacer()
                
                Image(colorScheme == .dark ? "simple-logo-dark" : "simple-logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.vertical, 32)
                                            
                VStack(spacing: 32) {
                    OSInputField(text: $email,
                                 title: "Email Address",
                                 placeholder: "name@example.com")
                    .autocapitalization(.none)
                    .frame(maxWidth: 500)
                    
                    VStack(spacing: 10) {
                        OSInputField(text: $password,
                                     title: "Password",
                                     placeholder: "Enter your password",
                                     isSecureField: true)
                        .autocapitalization(.none)
                        .frame(maxWidth: 500)
                        
                        NavigationLink {
                            ResetPasswordView()
                                .navigationBarHidden(true)
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.blue)
                                .frame(maxWidth: 500, alignment: .trailing)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(width: 175, height: 50)
                }
                .background(Color(colorScheme == .dark ? .white : .black))
                .cornerRadius(10)
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("Sign Up")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 24)
                }
            }
            .alert(isPresented: $viewModel.showAuthAlert, content: {
                Alert(title: Text(viewModel.authError?.title ?? AuthenticationError.unknown.title), message: Text(viewModel.authError?.description ?? AuthenticationError.unknown.description))
            })
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
