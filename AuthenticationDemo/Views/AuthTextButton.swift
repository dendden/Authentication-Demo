//
//  AuthTextButton.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

class AuthTextButton: UIButton {

    enum TextButtonSize {
        case small, medium
    }

    private let text: String
    private let size: TextButtonSize

    init(text: String, size: TextButtonSize) {
        self.text = text
        self.size = size
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {

        translatesAutoresizingMaskIntoConstraints = false
        configuration = .plain()
        setTitle(text, for: .normal)
        tintColor = .systemIndigo

        switch size {
        case .medium:
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
                var attributed = container
                attributed.font = .systemFont(ofSize: 16, weight: .medium)
                return attributed
            }
        case .small:
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
                var attributed = container
                attributed.font = .systemFont(ofSize: 14)
                return attributed
            }
        }
    }
}
