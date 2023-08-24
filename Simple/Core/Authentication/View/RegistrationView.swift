//
//  RegistrationView.swift
//  SIMPLE
//
//  Created by Charles Shin on 12/11/22.
//

import SwiftUI
import SFSafeSymbols

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                configuration.label
                Image(systemSymbol: configuration.isOn ? SFSymbol.checkmarkSquare : SFSymbol.square)
            }
            .frame(maxWidth: 500, alignment: .trailing)
        })
    }
}

struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @State var showPassword = false
    @State private var registerAsPolice = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Spacer()
            
            Image(colorScheme == .dark ? "simple-logo-dark" : "simple-logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical, 32)
            
            VStack(spacing: 32) {
                OSInputField(text: $fullname,
                             title: "Full Name",
                             placeholder: "Enter your name")
                .autocapitalization(.none)
                .textContentType(.name)
                .frame(maxWidth: 500)
                
                OSInputField(text: $email,
                             title: "Email Address",
                             placeholder: "name@example.com")
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .frame(maxWidth: 500)
                
                VStack(spacing: 10) {
                    HStack {
                        OSInputField(text: $password,
                                     title: "Create Password",
                                     placeholder: "Enter your password",
                                     isSecureField: !showPassword)
                        .textContentType(.newPassword)
                        .autocapitalization(.none)
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemSymbol: showPassword ? .eye : .eyeSlash)
                        }
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: 500)
                    
                    Toggle(isOn: $registerAsPolice) {
                        Text("Register as Police")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .toggleStyle(iOSCheckboxToggleStyle())
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                Button {
                    Task {
                        try await viewModel.registerUser(
                            withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            password: password,
                            fullname: fullname.trimmingCharacters(in: .whitespacesAndNewlines),
                            registeringAsPolice: registerAsPolice
                        )
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        
                        Image(systemSymbol: SFSymbol.arrowRight)
                    }
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(width: 175, height: 50)
                }
                .background(Color(colorScheme == .dark ? .white : .black))
                .cornerRadius(10)
                
                HStack(spacing: 2) {
                    Text("By signing up, you agree to our")
                    
                    Link(destination: URL(string: "https://www.simple-secure.org/eula")!) {
                        Text("Terms of Service")
                            .fontWeight(.semibold)
                    }
                }
                .font(.caption)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("Sign In")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 24)
            }
        }
        .alert(isPresented: $viewModel.showAuthAlert, content: {
            Alert(title: Text(viewModel.authError?.title ?? AuthenticationError.unknown.title), message: Text(viewModel.authError?.description ?? AuthenticationError.unknown.description))
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
