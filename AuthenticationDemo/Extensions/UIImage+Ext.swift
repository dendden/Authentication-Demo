//
//  UIImage+Ext.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 16.05.2023.
//

import UIKit

extension UIImage {

    func writeToDocuments(_ documentsPath: URL, name: String? = nil) {
        let imageName = name ?? UUID().uuidString
        var imagePath: URL
        if #available(iOS 16.0, *) {
            imagePath = documentsPath.appending(path: imageName)
        } else {
            imagePath = documentsPath.appendingPathComponent(imageName)
        }

        if let jpegData = jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
    }

    public convenience init?(from filePath: URL) {
        guard
            let jpegData = try? Data(contentsOf: filePath)
        else { return nil }

        self.init(data: jpegData)
    }
}
