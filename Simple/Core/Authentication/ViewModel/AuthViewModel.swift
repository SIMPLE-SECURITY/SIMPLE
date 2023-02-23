//
//  AuthViewModel.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import GeoFire
import GeoFireUtils

enum EmailVerificationStatus: Int, Codable {
    case unverified
    case emailSent
    case verified
}

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var emailVerificationStatus: EmailVerificationStatus = .unverified
    @Published var currentUser: User?
    @Published var authError: AuthenticationError?
    @Published var showAuthAlert = false
    @Published var deleteAlert = false
    let locationManager = LocationManager.shared
    
    init() {
        userSession = Auth.auth().currentUser
        self.emailVerificationStatus = userSession?.isEmailVerified ?? false ? .verified : .unverified
        
        Task {
            await fetchUser()
        }
    }
    
    @MainActor
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            self.emailVerificationStatus = userSession?.isEmailVerified ?? false ? .verified : .unverified
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
            self.showAuthAlert = true
            self.authError = AuthenticationError(localizedDescription: error.localizedDescription)
        }
    }
    
    @MainActor
    func registerUser(withEmail email: String, password: String, fullname: String) async throws {
        guard let location = locationManager.userLocation else { return }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(
                uid: result.user.uid,
                fullname: fullname,
                email: email,
                geopoint: GeoPoint(latitude: location.latitude, longitude: location.longitude)
            )
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
        } catch {
            print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
            self.showAuthAlert = true
            self.authError = AuthenticationError(localizedDescription: error.localizedDescription)
        }
    }
    
    @MainActor
    func sendVerificationEmail() async throws {
        do {
            try await Auth.auth().currentUser?.sendEmailVerification()
            emailVerificationStatus = .emailSent
        } catch {
            print("DEBUG: Failed to send verification email with error: \(error.localizedDescription)")
            self.showAuthAlert = true
            self.authError = .emailVerificationSent
        }
    }
    
    @MainActor
    func updateEmailVerificationStatus() async {
        do {
            try await Auth.auth().currentUser?.reload()
            self.userSession = Auth.auth().currentUser
            if let userSession = self.userSession, userSession.isEmailVerified {
                self.emailVerificationStatus = .verified
                await fetchUser()
            } else {
                self.authError = .unverifiedEmail
                self.showAuthAlert = true 
            }
        } catch {
            print("DEBUG: Failed to update firebase user with error: \(error.localizedDescription)")
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        self.currentUser = user
        
        UserDefaults.standard.set(user.fullname, forKey: "fullname")
        UserDefaults.standard.set(user.email, forKey: "email")
    }
    
    @MainActor
    func deleteAccount() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
            self.currentUser = nil
            self.userSession = nil
            self.emailVerificationStatus = .unverified
            self.deleteAlert = false
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
            self.deleteAlert = true
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
}
