//
//  SceneDelegate.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import FirebaseAuth
import UIKit

// swiftlint:disable line_length

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        configureWindow(with: scene)

        UINavigationBar.appearance().tintColor = .systemIndigo

        configureWithAuthStatus()
    }

    private func configureWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }

    public func configureWithAuthStatus() {
        if Auth.auth().currentUser != nil {
            let homeVC = HomeController()
            homeVC.title = "Welcome"
            let navController = UINavigationController(rootViewController: homeVC)

            animateToController(navController)
        } else {
            let loginVC = LoginController()
            loginVC.title = "Sign In"
            let navController = UINavigationController(rootViewController: loginVC)

            animateToController(navController)
        }
    }

    private func animateToController(_ viewController: UIViewController) {
        UIView.animate(withDuration: 0.15) {
            self.window?.layer.opacity = 0
        } completion: { _ in
            self.window?.rootViewController = viewController
            UIView.animate(withDuration: 0.25) {
                self.window?.layer.opacity = 1
            }
        }

    }

    // swiftlint:enable line_length
}
