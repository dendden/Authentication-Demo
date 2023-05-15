//
//  LoginController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign In", subtitle: "Sign in to your account")
    private let usernameTextField = AuthTextField(fieldType: .username)
    private let passwordTextField = AuthTextField(fieldType: .password, isLast: true)
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

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - UI Setup
    private func configure() {
        view.backgroundColor = .systemBackground

        usernameTextField.tag = 1
        usernameTextField.delegate = self
        passwordTextField.tag = 2
        passwordTextField.delegate = self

        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)

        createDismissKeyboardTapGesture()
    }

    /// Adds a tap gesture that dismisses keyboard to the view.
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tap)
    }

    private func setupUI() {
        view.addSubviews(
            headerView, usernameTextField, passwordTextField, signInButton, registerButton, forgotPasswordButton
        )

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),

            usernameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
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
    @objc private func didTapSignIn() {
        view.endEditing(true)
        let homeVC = HomeController()
        homeVC.title = "Welcome"
        navigationController?.pushViewController(homeVC, animated: true)
    }

    @objc private func didTapRegister() {
        let signupVC = SignupController()
        navigationController?.pushViewController(signupVC, animated: true)
    }

    @objc private func didTapForgotPassword() {
        let forgotVC = ForgotPasswordController()
        present(forgotVC, animated: true)
    }
}

extension LoginController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            passwordTextField.becomeFirstResponder()
        default:
            didTapSignIn()
        }

        return true
    }
}
