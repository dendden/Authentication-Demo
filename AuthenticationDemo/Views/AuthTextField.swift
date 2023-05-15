//
//  AuthTextField.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

class AuthTextField: UITextField {

    enum AuthTextFieldType {
        case username, password, email
    }

    enum AuthTextFieldState {
        case normal, invalid
    }

    private var fieldType: AuthTextFieldType
    private let isLast: Bool
    private let isRepeating: Bool

    init(fieldType: AuthTextFieldType, isLast: Bool = false, isRepeating: Bool = false) {
        self.fieldType = fieldType
        self.isLast = isLast
        self.isRepeating = isRepeating
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        setColor(for: .normal)
        borderStyle = .roundedRect
        autocorrectionType = .no
        autocapitalizationType = .none

        setKeyboardDoneButton()
        translatesAutoresizingMaskIntoConstraints = false

        switch fieldType {
        case .username:
            returnKeyType = .next
            textContentType = .name
            placeholder = "Username"
        case .email:
            returnKeyType = isLast ? .go : .next
            keyboardType = .emailAddress
            textContentType = .emailAddress
            placeholder = "Email"
        case .password:
            returnKeyType = isLast ? .go : .next
            textContentType = .password
            isSecureTextEntry = true
            placeholder = isRepeating ? "Repeat password" : "Password"
        }
    }

    private func setKeyboardDoneButton() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        bar.items = [spacer, done]
        inputAccessoryView = bar
    }

    func setColor(for state: AuthTextFieldState) {
        switch state {
        case .normal:
            backgroundColor = .secondarySystemBackground
            layer.borderColor = UIColor.secondarySystemFill.cgColor
        case .invalid:
            backgroundColor = .systemRed.withAlphaComponent(0.25)
            layer.borderColor = UIColor.systemRed.cgColor
        }
    }

    func setType(_ newType: AuthTextFieldType) {
        if fieldType == .username && newType == .email {
            fieldType = .email
            keyboardType = .emailAddress
            textContentType = .emailAddress
            placeholder = "Email"
        }
        if fieldType == .email && newType == .username {
            fieldType = .username
            keyboardType = .default
            textContentType = .name
            placeholder = "Username"
        }
    }
}
