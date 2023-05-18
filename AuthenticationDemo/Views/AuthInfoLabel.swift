//
//  AuthInfoLabel.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 17.05.2023.
//

import UIKit

class AuthInfoLabel: UILabel {

    init() {
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        font = UIFont(name: "Courier New Bold", size: 17)
    }
}
