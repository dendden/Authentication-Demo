//
//  AuthHeaderView.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

class AuthHeaderView: UIView {

    let circleHeight: CGFloat = 80
    let padding: CGFloat = 20

    // MARK: - UI Components
    private let circlePlaceholder = CircleView(height: 80, color: .systemIndigo)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureDefaultLabels()
        setupUI()
    }

    convenience init(title: String, subtitle: String) {
        self.init(frame: .zero)

        setLabelTexts(title: title, subtitle: subtitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    func setCover() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurView.frame = bounds
        addSubview(blurView)
    }

    func removeCover() {
        if let blurView = subviews.last as? UIVisualEffectView {
            blurView.removeFromSuperview()
        }
    }

    private func configureDefaultLabels() {
        titleLabel.text = "Title"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Subtitle"
        subtitleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setLabelTexts(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    private func setupUI() {
        addSubviews(circlePlaceholder, titleLabel, subtitleLabel)
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circlePlaceholder.topAnchor.constraint(equalTo: topAnchor),
            circlePlaceholder.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circlePlaceholder.heightAnchor.constraint(equalToConstant: circleHeight),
            circlePlaceholder.widthAnchor.constraint(equalToConstant: circleHeight),

            titleLabel.topAnchor.constraint(equalTo: circlePlaceholder.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
    }

}
