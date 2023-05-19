//
//  SignupController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import LocalAuthentication
import UIKit

class SignupController: UIViewController {

    // MARK: - Variables
    private var adjustableHeaderVerticalConstraint: NSLayoutConstraint!
    private var uiPublisher: UIPublishersManager!
    private var useBiometrics: Bool {
        get {
            UserDefaults.standard.bool(forKey: "use_biometrics")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "use_biometrics")
        }
    }

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign Up", subtitle: "Create a new account")
    private (set) var usernameTextField = AuthTextField(fieldType: .username)
    private (set) var emailTextField = AuthTextField(fieldType: .email)
    private (set) var passwordTextField = AuthTextField(fieldType: .password, passwordMode: .new)
    private (set) var signUpButton = AuthButton(title: "Sign Up")
    private let hasAccountButton = AuthTextButton(text: "Already have an account? Tap to sign in", size: .medium)
    private let termsText = UITextView()
    private let biometricsStack = UIStackView()
    private let biometricsLabel = UILabel()
    private let biometricsToggle = UISwitch()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - VC configuration
    private func configure() {
        view.backgroundColor = .systemBackground

        uiPublisher = UIPublishersManager(
            loginController: nil,
            signupController: self,
            forgotController: nil,
            type: .register
        )

        configureTextFields()

        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        hasAccountButton.addTarget(self, action: #selector(didTapHasAccount), for: .touchUpInside)

        let laContext = LAContext()
        var hasBiometry = true
        var bioError: NSError?

        laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &bioError)
        switch laContext.biometryType {
        case .faceID:
            biometricsLabel.text = "Use FaceID"
        case .touchID:
            biometricsLabel.text = "Use TouchID"
        default:
            hasBiometry = false
        }
        if hasBiometry {
            biometricsToggle.isOn = useBiometrics
            biometricsStack.axis = .horizontal
            biometricsStack.distribution = .fill
            biometricsStack.addArrangedSubview(biometricsLabel)
            biometricsStack.addArrangedSubview(biometricsToggle)
            biometricsStack.translatesAutoresizingMaskIntoConstraints = false
            biometricsToggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        }

        setupUI(showBiometry: hasBiometry)

        configureTermsText()
    }

    /// Adds a tap gesture that dismisses keyboard to the view.
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tap)
    }

    private func configureTextFields() {
        usernameTextField.tag = 1
        usernameTextField.delegate = self
        emailTextField.tag = 2
        emailTextField.delegate = self
        passwordTextField.tag = 3
        passwordTextField.delegate = self

        NotificationCenter.default.addObserver(
            self, selector: #selector(adjustPaddingForKeyboardShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(adjustPaddingForKeyboardHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        createDismissKeyboardTapGesture()
    }

    private func configureTermsText() {
        termsText.translatesAutoresizingMaskIntoConstraints = false

        // swiftlint:disable:next line_length
        let textString = "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy."
        let attrString = NSMutableAttributedString(string: textString)
        attrString.addAttribute(
            .link,
            value: "terms://terms",
            range: (attrString.string as NSString).range(of: "Terms & Conditions")
        )
        attrString.addAttribute(
            .link,
            value: "privacy://privacy",
            range: (attrString.string as NSString).range(of: "Privacy Policy")
        )

        termsText.linkTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        termsText.attributedText = attrString
        termsText.font = .preferredFont(forTextStyle: .caption1)
        termsText.textAlignment = .center
        termsText.isEditable = false
        termsText.isScrollEnabled = false
        termsText.delaysContentTouches = false

        termsText.delegate = self
    }

    // MARK: - UI Setup
    private func setupUI(showBiometry: Bool) {
        view.addSubviews(
            headerView, usernameTextField, emailTextField, passwordTextField,
            signUpButton, hasAccountButton, termsText
        )

        let padding: CGFloat = 20

        adjustableHeaderVerticalConstraint = usernameTextField.topAnchor.constraint(
            equalTo: headerView.bottomAnchor, constant: 50
        )

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),

            adjustableHeaderVerticalConstraint,
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),

            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            termsText.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            termsText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            termsText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            termsText.heightAnchor.constraint(equalToConstant: 50),

            hasAccountButton.topAnchor.constraint(equalTo: termsText.bottomAnchor, constant: 20),
            hasAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            hasAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            hasAccountButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        if showBiometry {
            view.addSubview(biometricsStack)
            NSLayoutConstraint.activate([
                biometricsStack.topAnchor.constraint(equalTo: hasAccountButton.bottomAnchor, constant: 30),
                biometricsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                biometricsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                biometricsStack.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }

    // MARK: - Selectors
    @objc private func didTapSignUp() {

        view.endEditing(true)
        signUpButton.setProcessing(true)

        let registerRequest = RegistrationRequest(
            username: uiPublisher.formViewModel.username,
            email: uiPublisher.formViewModel.email,
            password: uiPublisher.formViewModel.password
        )

        Task {
            do {
                try await AuthService.shared.registerUser(request: registerRequest)
                DispatchQueue.main.async {
                    self.signUpButton.setProcessing(false)
                }
                configureSceneAuthStatus()
            } catch let error {
                DispatchQueue.main.async {
                    self.signUpButton.setProcessing(false)
                }
                showRegistrationAlert(with: error)
            }
        }
    }

    @objc private func didTapHasAccount() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func adjustPaddingForKeyboardShow() {
        UIView.animate(withDuration: 0.1) {
            self.headerView.setCover()
            self.adjustableHeaderVerticalConstraint.constant = -50
            self.view.layoutIfNeeded()
        }
    }

    @objc private func adjustPaddingForKeyboardHide() {
        UIView.animate(withDuration: 0.1) {
            self.adjustableHeaderVerticalConstraint.constant = 50
            self.headerView.removeCover()
            self.view.layoutIfNeeded()
        }
    }

    @objc private func toggleValueChanged() {
        useBiometrics = biometricsToggle.isOn
    }
}

// MARK: - Protocols Conformance
extension SignupController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 3:
            didTapSignUp()
        default:
            let nextTag = textField.tag + 1
            if let nextTextField = textField.superview?.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }

        return true
    }
}

extension SignupController: UITextViewDelegate {

    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {

        switch URL.scheme {
        case "terms":
            print(">>> Show Ts&Cs")
        case "privacy":
            print(">>> Show Privacy Policy")
        default:
            print(">>> Unknown text link scheme")
        }

        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
