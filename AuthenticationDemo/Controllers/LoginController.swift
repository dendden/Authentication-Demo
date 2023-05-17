//
//  LoginController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import Combine
import UIKit

class LoginController: UIViewController {

    enum AuthSystem: String {
        case firebase = "Firebase"
        case nodeJS = "Node.js"
    }

    // MARK: - Variables
    private (set) var selectedAuthSystem = AuthSystem.nodeJS
    private var uiPublisher: UIPublishersManager!

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign In", subtitle: "Sign in to your account")
    private (set) var usernameTextField = AuthTextField(fieldType: .username)
    private (set) var passwordTextField = AuthTextField(fieldType: .password)
    private (set) var signInButton = AuthButton(title: "Sign In")
    private let registerButton = AuthTextButton(text: "New user? Create account", size: .medium)
    private let forgotPasswordButton = AuthTextButton(text: "Forgot password?", size: .small)
    private let authSystemPicker = UISegmentedControl()

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

    // MARK: - VC configuration
    private func configure() {
        view.backgroundColor = .systemBackground

        uiPublisher = UIPublishersManager(
            loginController: self,
            signupController: nil,
            forgotController: nil,
            type: selectedAuthSystem == .nodeJS ? .loginNJS : .loginFirebase
        )

        usernameTextField.tag = 1
        usernameTextField.delegate = self
        passwordTextField.tag = 2
        passwordTextField.delegate = self

        configureButtons()
        configureAuthSelector()

        createDismissKeyboardTapGesture()
    }

    private func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }

    private func configureAuthSelector() {
        authSystemPicker.translatesAutoresizingMaskIntoConstraints = false
        authSystemPicker.tintColor = .systemIndigo
        authSystemPicker.insertSegment(withTitle: AuthSystem.firebase.rawValue, at: 0, animated: true)
        authSystemPicker.insertSegment(withTitle: AuthSystem.nodeJS.rawValue, at: 1, animated: true)
        authSystemPicker.selectedSegmentIndex = 1
        authSystemPicker.addTarget(self, action: #selector(authPickerSelectionChanged), for: .allEvents)
    }

    /// Adds a tap gesture that dismisses keyboard to the view.
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tap)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubviews(
            headerView, usernameTextField, passwordTextField, signInButton, registerButton,
            forgotPasswordButton, authSystemPicker
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
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),

            authSystemPicker.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 30),
            authSystemPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            authSystemPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            authSystemPicker.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Selectors
    @objc private func didTapSignIn() {
        view.endEditing(true)
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.configureWithAuthStatus()
        }
    }

    @objc private func didTapRegister() {
        let signupVC = SignupController()
        navigationController?.pushViewController(signupVC, animated: true)
    }

    @objc private func didTapForgotPassword() {
        let forgotVC = ForgotPasswordController()
        let navController = UINavigationController(rootViewController: forgotVC)
        present(navController, animated: true)
    }

    @objc private func authPickerSelectionChanged() {
        usernameTextField.text?.removeAll()
        usernameTextField.setColor(for: .normal)
        passwordTextField.text?.removeAll()
        passwordTextField.setColor(for: .normal)
        if authSystemPicker.selectedSegmentIndex == 0 {
            selectedAuthSystem = .firebase
            usernameTextField.setType(.email)
            uiPublisher = UIPublishersManager(
                loginController: self,
                signupController: nil,
                forgotController: nil,
                type: .loginFirebase
            )
        } else {
            selectedAuthSystem = .nodeJS
            usernameTextField.setType(.username)
            uiPublisher = UIPublishersManager(
                loginController: self,
                signupController: nil,
                forgotController: nil,
                type: .loginNJS
            )
        }
    }
}

// MARK: - Protocols Conformance
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
