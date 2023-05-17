//
//  UIViewController+Ext.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 15.05.2023.
//

import UIKit

extension UIViewController {

    func configureSceneAuthStatus() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            DispatchQueue.main.async {
                sceneDelegate.configureWithAuthStatus()
            }
        }
    }

    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let gotitAction = UIAlertAction(title: "Got it", style: .default)
        alert.addAction(gotitAction)

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
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

    func showResetPasswordAlert() {
        showAlert(title: "Password Reset Error", message: "An unexpected error occurred. Please try again later.")
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
