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

    private let fieldType: AuthTextFieldType
    private let isLast: Bool

    init(fieldType: AuthTextFieldType, isLast: Bool = false) {
        self.fieldType = fieldType
        self.isLast = isLast
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

        translatesAutoresizingMaskIntoConstraints = false

        switch fieldType {
        case .username:
            returnKeyType = .next
            placeholder = "Username"
        case .password:
            returnKeyType = isLast ? .go : .next
            textContentType = .password
            isSecureTextEntry = true
            placeholder = "Password"
        case .email:
            returnKeyType = isLast ? .go : .next
            keyboardType = .emailAddress
            textContentType = .emailAddress
            placeholder = "Email"
        }
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

}
