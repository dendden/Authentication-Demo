//
//  UIView+Ext.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 14.05.2023.
//

import UIKit

extension UIView {

    /// Adds multiple subviews to this view.
    /// - Parameter views: A variadic collection of subviews to add.
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
