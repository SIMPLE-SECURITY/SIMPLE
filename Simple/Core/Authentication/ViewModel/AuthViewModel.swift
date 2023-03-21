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

// detect emoji in string
extension String {

    var notContainsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x2600...0x26FF,   // Misc symbols
                 0x2700...0x27BF,   // Dingbats
                 0xFE00...0xFE0F:   // Variation Selectors
                return false
            default:
                continue
            }
        }
        return true
    }

}

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var emailVerificationStatus: EmailVerificationStatus = .unverified
    @Published var currentUser: User?
    @Published var authError: AuthenticationError?
    @Published var showAuthAlert = false
    @Published var settingAlert = false
    @Published var signoutAlert = false
    @Published var deleteAlert = false
    @Published var changeSuccessful = false
    @Published var changeUnsuccessful = false
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
    
    func endsWithAny(_ string: String, _ suffixes: [String]) -> Bool {
        for suffix in suffixes {
            if string.hasSuffix(suffix) {
                return true
            }
        }
        return false
    }
    
    @MainActor
    func registerUser(withEmail email: String, password: String, fullname: String, registeringAsPolice: Bool) async throws {
        guard let location = locationManager.userLocation else { return }
        guard fullname.notContainsEmoji else {
            self.showAuthAlert = true
            self.authError = AuthenticationError(localizedDescription: "full name contains emoji")
            return
        }
        guard endsWithAny(email, institutionalEmailDomains) else {
            self.showAuthAlert = true
            self.authError = AuthenticationError(localizedDescription: "email address is not in registered academia")
            return
        }
        if (registeringAsPolice == true) {
            guard (polices.contains(email) || endsWithAny(email, policeEmailDomains)) else {
                self.showAuthAlert = true
                self.authError = AuthenticationError(localizedDescription: "email address is not registered as a part of the local law enforcement")
                return
            }
        }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // 'verified' icon; verify new email as police's
            // user should be 1. registering as police (checkmark) 2. have the required email address
            let fullnamePoliceChecked = (registeringAsPolice && (polices.contains(email) || endsWithAny(email, policeEmailDomains))) ? fullname + " 👮‍♂️" : fullname
            self.userSession = result.user
            let user = User(
                uid: result.user.uid,
                fullname: fullnamePoliceChecked,
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
            self.settingAlert = false
            self.signoutAlert = false
        } catch {
            self.settingAlert = true
            self.signoutAlert = true
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        
        let userName = user.fullname
        let userEmail = user.email
        let userIsPolice = (polices.contains(userEmail) || endsWithAny(userEmail, policeEmailDomains))
        let userIsCataloguedAsPolice = (userName).contains("👮‍♂️")
        
        // if police account is now not police, then downgrade to basic account so as to prevent malicious use
        if userIsCataloguedAsPolice && (!userIsPolice) {
            try? await COLLECTION_USERS.document(uid).updateData([
                "fullname": String(userName.prefix(userName.count - 2))
            ])
        }
        
        snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        
        self.currentUser = user
        
        UserDefaults.standard.set(user.fullname, forKey: "fullname")
        UserDefaults.standard.set(user.email, forKey: "email")
    }
    
    @MainActor
    func reqeustChange() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }

        let userName = user.fullname
        let userEmail = user.email
        let userIsPolice = (polices.contains(userEmail) || endsWithAny(userEmail, policeEmailDomains))
        let userIsCataloguedAsPolice = (userName).contains("👮‍♂️")

        // only regular -> police should be checked
        if userIsCataloguedAsPolice { // police -> regular
            try? await COLLECTION_USERS.document(uid).updateData([
                "fullname": String(userName.prefix(userName.count - 2))
            ])
            self.changeUnsuccessful = false
            self.changeSuccessful = true
        } else {
            if userIsPolice {
                try? await COLLECTION_USERS.document(uid).updateData([
                    "fullname": userName + " 👮‍♂️"
                ])
                self.changeUnsuccessful = false
                self.changeSuccessful = true
            } else {
                self.changeSuccessful = false
                self.changeUnsuccessful = true
            }
        }

        // redeclare snapshot and "user" variable
        snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        
        self.currentUser = user
        
        UserDefaults.standard.set(user.fullname, forKey: "fullname")
        UserDefaults.standard.set(user.email, forKey: "email")
        
        self.settingAlert = true
    }
    
    @MainActor
    func deleteAccount() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
            self.currentUser = nil
            self.userSession = nil
            self.emailVerificationStatus = .unverified
            self.settingAlert = false
            self.deleteAlert = false
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
            self.settingAlert = true
            self.deleteAlert = true
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
}
