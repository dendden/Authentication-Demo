//
//  LoginController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Variables

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign In", subtitle: "Sign in to your account")
    private let usernameTexField = AuthTextField(fieldType: .username)
    private let passwordTexField = AuthTextField(fieldType: .password, isLast: true)
    private let signInButton = AuthButton(title: "Sign In")
    private let registerButton = AuthTextButton(text: "New user? Create account", size: .medium)
    private let forgotPasswordButton = AuthTextButton(text: "Forgot password?", size: .small)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - UI Setup
    private func configure() {
        view.backgroundColor = .systemBackground
    }

    private func setupUI() {
        view.addSubviews(
            headerView, usernameTexField, passwordTexField, signInButton, registerButton, forgotPasswordButton
        )

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),

            usernameTexField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 50),
            usernameTexField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameTexField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameTexField.heightAnchor.constraint(equalToConstant: 50),

            passwordTexField.topAnchor.constraint(equalTo: usernameTexField.bottomAnchor, constant: 20),
            passwordTexField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTexField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTexField.heightAnchor.constraint(equalToConstant: 50),

            signInButton.topAnchor.constraint(equalTo: passwordTexField.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            registerButton.heightAnchor.constraint(equalToConstant: 20),

            forgotPasswordButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Selectors

}
