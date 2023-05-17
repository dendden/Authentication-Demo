//
//  UIPublishersManager.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 16.05.2023.
//

import UIKit

final class UIPublishersManager {

    private var formViewModel: FormViewModel!
    weak var loginController: LoginController?
    weak var signupController: SignupController?
    weak var forgotController: ForgotPasswordController?
    let type: FormType

    init(
        loginController: LoginController?,
        signupController: SignupController?,
        forgotController: ForgotPasswordController?,
        type: FormType
    ) {
        self.formViewModel = FormViewModel(formType: type)
        self.loginController = loginController
        self.signupController = signupController
        self.forgotController = forgotController
        self.type = type
    }

    public func configurePublishers() {
        switch type {
        case .register:
            break
        case .forgot:
            break
        default:
            configureLoginPublishers()
        }
    }

    private func configureLoginPublishers() {

        guard let loginController else { fatalError("Unexpected nil ViewController for UI publisher.") }

        switch loginController.selectedAuthSystem {
        case .nodeJS:
            setUsernamePublishers(usernameTextField: loginController.usernameTextField)
            formViewModel?.isEmailValid = true
        case .firebase:
            setFirebaseUsernamePublishers(usernameTextField: loginController.usernameTextField)
            formViewModel?.isUsernameValid = true
        }

        setPasswordPublishers(passwordTextField: loginController.passwordTextField)
        setSubmitEnabledPublisher(submitButton: loginController.signInButton)
    }

    private func setUsernamePublishers(usernameTextField: AuthTextField) {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: usernameTextField)
            .compactMap { [weak self] in self?.mapTextFromOutput($0) }
            .assign(to: \.username, on: formViewModel)
            .store(in: &formViewModel.cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: usernameTextField)
            .sink { [weak self] _ in
                print(">>> setting username valid pub on: \(Thread.current)")
                self?.setUsernameValidPublisher(usernameTextField: usernameTextField)
            }
            .store(in: &formViewModel.cancellables)
    }

    private func setFirebaseUsernamePublishers(usernameTextField: AuthTextField) {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: usernameTextField)
            .compactMap { [weak self] in self?.mapTextFromOutput($0) }
            .assign(to: \.email, on: formViewModel)
            .store(in: &formViewModel.cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: usernameTextField)
            .sink { [weak self] _ in self?.setEmailValidPublisher(emailTextField: usernameTextField) }
            .store(in: &formViewModel.cancellables)
    }

    private func setPasswordPublishers(passwordTextField: AuthTextField) {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap { [weak self] in self?.mapTextFromOutput($0) }
            .assign(to: \.password, on: formViewModel)
            .store(in: &formViewModel.cancellables)

        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: passwordTextField)
            .sink { [weak self] _ in self?.setPasswordValidPublisher(passwordTextField: passwordTextField) }
            .store(in: &formViewModel.cancellables)
    }

    private func mapTextFromOutput(_ output: NotificationCenter.Publisher.Output) -> String? {
        if let textField = output.object as? AuthTextField {
            return textField.text
        } else {
            return nil
        }
    }

    private func setUsernameValidPublisher(usernameTextField: AuthTextField) {
        formViewModel.$isUsernameValid
            .sink { isValid in
                if isValid {
                    print(">>> setting username field green color pub on: \(Thread.current)")
                    usernameTextField.setColor(for: .valid)
                } else {
                    print(">>> setting username field red color pub on: \(Thread.current)")
                    usernameTextField.setColor(for: .invalid)
                }
            }
            .store(in: &formViewModel.cancellables)
    }

    private func setEmailValidPublisher(emailTextField: AuthTextField) {
        formViewModel.$isEmailValid
            .sink { isValid in
                if isValid {
                    emailTextField.setColor(for: .valid)
                } else {
                    emailTextField.setColor(for: .invalid)
                }
            }
            .store(in: &formViewModel.cancellables)
    }

    private func setPasswordValidPublisher(passwordTextField: AuthTextField) {
        formViewModel.$isPasswordValid
            .sink { isValid in
                if isValid {
                    passwordTextField.setColor(for: .valid)
                } else {
                    passwordTextField.setColor(for: .invalid)
                }
            }
            .store(in: &formViewModel.cancellables)
    }

    private func setSubmitEnabledPublisher(submitButton: AuthButton) {
        formViewModel.$isSubmitEnabled
            .sink { isEnabled in
                if isEnabled {
                    print(">>> setting submit enabled pub on: \(Thread.current)")
                    submitButton.isEnabled = true
                    submitButton.layer.opacity = 1
                } else {
                    print(">>> setting submit disabled pub on: \(Thread.current)")
                    submitButton.isEnabled = false
                    submitButton.layer.opacity = 0.5
                }
            }
            .store(in: &formViewModel.cancellables)
    }
}
