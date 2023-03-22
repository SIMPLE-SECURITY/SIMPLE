//
//  SettingMessage.swift
//  Simple
//
//  Created by Charles Shin on 2/13/23.
//

enum SettingMessage: Error {
    case signoutFailed
    case confirmingDelete
    case changeUnsuccessful
    case changeToPoliceSuccessful
    case changeToBasicSuccessful
    case deleteFailed
    case unknown
    
    init(localizedDescription: String) {
        if localizedDescription.contains("signout failed") {
            self = .signoutFailed
        } else if localizedDescription.contains("deleting account") {
            self = .confirmingDelete
        } else if localizedDescription.contains("change unsuccessful") {
            self = .changeUnsuccessful
        } else if localizedDescription.contains("change to police successful") {
            self = .changeToPoliceSuccessful
        } else if localizedDescription.contains("change to basic successful") {
            self = .changeToBasicSuccessful
        } else if localizedDescription.contains("deletion failed") {
            self = .deleteFailed
        } else {
            self = .unknown
        }
    }
    
    var title: String {
        switch self {
        case .signoutFailed:
            return "Sign Out Failed"
        case .confirmingDelete:
            return "Delete Account"
        case .changeUnsuccessful:
            return "Change Unsuccessful"
        case .changeToPoliceSuccessful:
            return "Change Successful!"
        case .changeToBasicSuccessful:
            return "Change Successful!"
        case .deleteFailed:
            return "Authentication Required"
        case .unknown:
            return "Error"
        }
    }
    
    var description: String {
        switch self {
        case .signoutFailed:
            return "Sorry, we could not sign you out at this time. Please try again later."
        case .confirmingDelete:
            return "Are you sure you want to delete your account? This will permanently erase your account."
        case .changeUnsuccessful:
            return "Your email address is not recognized as belonging to local law enforcement. Please contact charlesshin@simple-secure.org if you would like to add your email as eligible for a police account."
        case .changeToPoliceSuccessful:
            return "Your account has been successfully changed to a police account."
        case .changeToBasicSuccessful:
            return "Your account has been successfully changed to a basic account."
        case .deleteFailed:
            return "Deleting your account requires authentication. Log in again before retrying it."
        case .unknown:
            return "An error occurred while processing your request. Please try again later."
        }
    }
}
