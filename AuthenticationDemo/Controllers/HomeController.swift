//
//  HomeController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import UIKit

class HomeController: UIViewController {

    let homeImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configure() {
        view.backgroundColor = .systemTeal

        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = signOutButton

        let image = UIImage(systemName: "sun.dust")
        homeImageView.image = image
        homeImageView.contentMode = .scaleAspectFit
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        homeImageView.tintColor = .systemOrange

        view.addSubview(homeImageView)

        NSLayoutConstraint.activate([
            homeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            homeImageView.widthAnchor.constraint(equalToConstant: 250),
            homeImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    @objc private func signOut() {
        do {
            try AuthService.shared.logout()
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.configureWithAuthStatus()
            }
        } catch let error {
            showLogoutAlert(with: error)
        }
    }
}
