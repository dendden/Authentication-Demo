//
//  FileManager+Ext.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 16.05.2023.
//

import Foundation

extension FileManager {

    /// A shortcut to the `URL` of `.documentsDirectory` in `.userDomainMask`.
    var documentsDirectory: URL? {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}
