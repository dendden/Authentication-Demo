//
//  CircleView.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

class CircleView: UIView {

    init(height: CGFloat, color: UIColor) {
        super.init(frame: .zero)

        configure(height: height, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(height: CGFloat, color: UIColor) {
        layer.cornerRadius = height / 2
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
    }
}
