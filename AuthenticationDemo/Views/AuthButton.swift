//
//  AuthButton.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

class AuthButton: UIButton {

    private var title: String

    private var activityIndicator: UIActivityIndicatorView

    init(title: String) {
        self.title = title
        activityIndicator = UIActivityIndicatorView(style: .medium)
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
        configureActivityIndicator()
    }

    private func configureActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    public func setProcessing(_ isProcessing: Bool) {
        if isProcessing {
            isEnabled = false
            alpha = 0.5
            activityIndicator.startAnimating()
        } else {
            isEnabled = true
            alpha = 1
            activityIndicator.stopAnimating()
        }
    }
}
