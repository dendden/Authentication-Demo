//
//  UIViewController+Ext.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 15.05.2023.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let gotitAction = UIAlertAction(title: "Got it", style: .default)
        alert.addAction(gotitAction)

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    func showInvalidEmailAlert() {
        showAlert(title: "Invalid Email", message: "Please provide a valid email address.")
    }

    func showInvalidPasswordAlert() {
        showAlert(title: "Incorrect Password", message: "The password you've entered is not valid. Please try again.")
    }

    func showInvalidUsernameAlert() {
        showAlert(title: "User Not Found", message: "Please enter an existing username.")
    }

    func showRegistrationAlert() {
        showAlert(title: "Registration Error", message: "An unexpected error occurred. Please try again later.")
    }

    func showRegistrationAlert(with error: Error) {
        showAlert(title: "Registration Error", message: error.localizedDescription)
    }

    func showLoginAlert() {
        showAlert(title: "Login Error", message: "An unexpected error occurred. Please try again later.")
    }

    func showLoginAlert(with error: Error) {
        showAlert(title: "Login Error", message: error.localizedDescription)
    }

    func showLogoutAlert(with error: Error) {
        showAlert(title: "Logout Error", message: error.localizedDescription)
    }

    func showResetPasswordAlert(with error: Error) {
        showAlert(title: "Reset Error", message: error.localizedDescription)
    }

    func showResetPasswordSuccessAlert() {
        showAlert(title: "Password reset", message: "Please check your email for further instructions.")
    }

    func showUserFetchAlert() {
        showAlert(title: "Error Fetching User Data", message: "An unexpected error occurred. Please try again later.")
    }

    func showUserFetchAlert(with error: Error) {
        showAlert(title: "Error Fetching User Data", message: error.localizedDescription)
    }
}
