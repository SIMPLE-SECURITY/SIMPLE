//
//  AuthenticationError.swift
//  Simple
//
//  Created by Charles Shin on 2/13/23.
//

enum AuthenticationError: Error {
    case emailFormatting
    case emailDoesNotExist
    case emailInUse
    case passwordIncorrect
    case passwordFormatting
    case unverifiedEmail
    case emailVerificationSent
    case nameHasEmoji
    case emailIsNotInAcademia
    case emailIsNotRegisteredAsPolice
    case unknown
    
    init(localizedDescription: String) {
        if localizedDescription.contains("email address is badly formatted") {
            self = .emailFormatting
        } else if localizedDescription.contains("no user record corresponding to this identifier") {
            self = .emailDoesNotExist
        } else if localizedDescription.contains("password is invalid or the user does not have a password") {
            self = .passwordIncorrect
        } else if localizedDescription.contains("The password must be 6 characters long or more") {
            self = .passwordFormatting
        } else if localizedDescription.contains("email address is already in use") {
            self = .emailInUse
        } else if localizedDescription.contains("emoji") {
            self = .nameHasEmoji
        } else if localizedDescription.contains("registered academia") {
            self = .emailIsNotInAcademia
        } else if localizedDescription.contains("local law enforcement") {
            self = .emailIsNotRegisteredAsPolice
        } else {
            self = .unknown
        }
    }
    
    var title: String {
        switch self {
        case .emailFormatting:
            return "Invalid Email"
        case .emailDoesNotExist:
            return "Email Not Found"
        case .emailInUse:
            return "Email Already in Use"
        case .passwordIncorrect:
            return "Incorrect Password"
        case .passwordFormatting:
            return "Invalid Password"
        case .unverifiedEmail:
            return "Unverified Email"
        case .emailVerificationSent:
            return "Verification Already Sent"
        case .nameHasEmoji:
            return "Name Contains Emoji"
        case .emailIsNotInAcademia:
            return "Email Not Registered in Academia"
        case .emailIsNotRegisteredAsPolice:
            return "Email Not Registered as Police"
        case .unknown:
            return "Error"
        }
    }
    
    var description: String {
        switch self {
        case .emailFormatting:
            return "The email address you have entered is not properly formatted. Please try again."
        case .emailDoesNotExist:
            return "We could not find a user with the provided email address. This account may have been deleted."
        case .emailInUse:
            return "This email address is already registered. Please choose a different email and try again, or click \"Forgot Password?\" in Login page to reset your password."
        case .passwordIncorrect:
            return "Your password is incorrect or does not exist. Please try again."
        case .passwordFormatting:
            return "Your password must be at least 6 characters or more. Please try again."
        case .unverifiedEmail:
            return "It looks like your email hasn't been verified yet. Please check your inbox and try again, or click below the button to resend the verification link."
        case .emailVerificationSent:
            return "It looks like we already sent you an email. Please check your inbox, as well as your spam or junk folder, and try again."
        case .nameHasEmoji:
            return "Name should not have emojis. Please try again."
        case .emailIsNotInAcademia:
            return "This email address is not part of the registered institutions. We need your institutional email to prevent spamming. Please contact charlesshin@simple-secure.org to add your institution."
        case .emailIsNotRegisteredAsPolice:
            return "This email address is not registered as a part of the local law enforcement. Please reach out to charlesshin@simple-secure.org in order to register either your specific email address or your institution as a local law enforcement agency."
        case .unknown:
            return "An error occurred while searching for your account. Please try again later."
        }
    }
}
