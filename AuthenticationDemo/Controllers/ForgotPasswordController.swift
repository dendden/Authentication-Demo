//
//  ForgotPasswordController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import UIKit

class ForgotPasswordController: UIViewController {

    // MARK: - Variables
    private var uiPublisher: UIPublishersManager!

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Reset Password", subtitle: "Enter email to reset your password")
    private (set) var emailTextField = AuthTextField(fieldType: .email, isLast: true)
    private (set) var resetPasswordButton = AuthButton(title: "Reset Password")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - VC configuration
    private func configure() {
        view.backgroundColor = .systemBackground

        uiPublisher = UIPublishersManager(
            loginController: nil,
            signupController: nil,
            forgotController: self,
            type: .forgot
        )

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        resetPasswordButton.addTarget(self, action: #selector(didTapResetPassword), for: .touchUpInside)

        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubviews(headerView, emailTextField, resetPasswordButton)

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),

            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            resetPasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            resetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            resetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Selectors
    /// Dismisses this `ViewController` with animation.
    @objc private func dismissVC() {
        dismiss(animated: true)
    }

    @objc private func didTapResetPassword() {
        view.endEditing(true)
        resetPasswordButton.setProcessing(true)

        Task {
            do {
                try await AuthService.shared.forgotPassword(for: uiPublisher.formViewModel.email)
                DispatchQueue.main.async {
                    self.resetPasswordButton.setProcessing(false)
                }
                showResetPasswordSuccessAlert()
            } catch let error {
                DispatchQueue.main.async {
                    self.resetPasswordButton.setProcessing(false)
                }
                showResetPasswordAlert(with: error)
            }
        }
    }
}
