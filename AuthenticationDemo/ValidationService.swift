//
//  ValidationService.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 15.05.2023.
//

import Foundation

class ValidationService {

    static func isValidEmail(_ email: String) -> Bool {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailPredicate.evaluate(with: cleanEmail)
    }

    static func isValidUsername(_ username: String) -> Bool {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRegEx = "\\w{4,24}"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)

        return usernamePredicate.evaluate(with: cleanUsername)
    }

    static func isValidPassword(_ password: String) -> Bool {
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passRegEx = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,32}$"
        let passPredicate = NSPredicate(format: "SELF MATCHES %@", passRegEx)

        return passPredicate.evaluate(with: cleanPassword)
    }
}
