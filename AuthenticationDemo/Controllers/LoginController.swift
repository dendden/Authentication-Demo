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

    private var selectedAuthSystem = AuthSystem.nodeJS
    private var viewModel = FormViewModel(formType: .loginNJS)

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign In", subtitle: "Sign in to your account")
    private let usernameTextField = AuthTextField(fieldType: .username)
    private let passwordTextField = AuthTextField(fieldType: .password)
    private let signInButton = AuthButton(title: "Sign In")
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

    // MARK: - UI Setup
    private func configure() {
        view.backgroundColor = .systemBackground

        usernameTextField.tag = 1
        usernameTextField.delegate = self
        passwordTextField.tag = 2
        passwordTextField.delegate = self

        configureButtons()
        configureAuthSelector()
        configurePublishers()

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
            viewModel = FormViewModel(formType: .loginFirebase)
        } else {
            selectedAuthSystem = .nodeJS
            usernameTextField.setType(.username)
            viewModel = FormViewModel(formType: .loginNJS)
        }
        configurePublishers()
    }

    // MARK: - Publishers:
    private func configurePublishers() {

        switch selectedAuthSystem {
        case .nodeJS:
            setNodeJSUsernamePublishers()
            viewModel.isEmailValid = true
        case .firebase:
            setFirebaseUsernamePublishers()
            viewModel.isUsernameValid = true
        }

        setPasswordPublishers()
        setSubmitEnabledPublisher()
    }

    private func setNodeJSUsernamePublishers() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: usernameTextField)
            .compactMap { [weak self] in self?.mapTextFromOutput($0) }
            .assign(to: \.username, on: viewModel)
            .store(in: &viewModel.cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: usernameTextField)
            .sink { [weak self] _ in self?.setUsernameValidPublisher() }
            .store(in: &viewModel.cancellables)
    }

    private func setFirebaseUsernamePublishers() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: usernameTextField)
            .compactMap { [weak self] in self?.mapTextFromOutput($0) }
            .assign(to: \.email, on: viewModel)
            .store(in: &viewModel.cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: usernameTextField)
            .sink { [weak self] _ in self?.setEmailValidPublisher() }
            .store(in: &viewModel.cancellables)
    }

    private func setPasswordPublishers() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap { [weak self] in self?.mapTextFromOutput($0) }
            .assign(to: \.password, on: viewModel)
            .store(in: &viewModel.cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: passwordTextField)
            .sink { [weak self] _ in self?.setPasswordValidPublisher() }
            .store(in: &viewModel.cancellables)
    }

    private func mapTextFromOutput(_ output: NotificationCenter.Publisher.Output) -> String? {
        if let textField = output.object as? AuthTextField {
            return textField.text
        } else {
            return nil
        }
    }

    private func setUsernameValidPublisher() {
        viewModel.$isUsernameValid
            .sink { [weak self] isValid in
                guard let self else { return }
                if isValid {
                    self.usernameTextField.setColor(for: .valid)
                } else {
                    self.usernameTextField.setColor(for: .invalid)
                }
            }
            .store(in: &viewModel.cancellables)
    }

    private func setEmailValidPublisher() {
        viewModel.$isEmailValid
            .sink { [weak self] isValid in
                guard let self else { return }
                if isValid {
                    self.usernameTextField.setColor(for: .valid)
                } else {
                    self.usernameTextField.setColor(for: .invalid)
                }
            }
            .store(in: &viewModel.cancellables)
    }

    private func setPasswordValidPublisher() {
        viewModel.$isPasswordValid
            .sink { [weak self] isValid in
                guard let self else { return }
                if isValid {
                    self.passwordTextField.setColor(for: .valid)
                } else {
                    self.passwordTextField.setColor(for: .invalid)
                }
            }
            .store(in: &viewModel.cancellables)
    }

    private func setSubmitEnabledPublisher() {
        viewModel.$isSubmitEnabled
            .sink { [weak self] isEnabled in
                guard let self else { return }
                if isEnabled {
                    self.signInButton.isEnabled = true
                    self.signInButton.layer.opacity = 1
                } else {
                    self.signInButton.isEnabled = false
                    self.signInButton.layer.opacity = 0.5
                }
            }
            .store(in: &viewModel.cancellables)
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
