//
//  AuthButton.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

class AuthButton: UIButton {

    private let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        configuration = .filled()
        configuration?.cornerStyle = .medium
        tintColor = .systemIndigo
    }
}
