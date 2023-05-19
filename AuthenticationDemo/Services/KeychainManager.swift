//
//  KeychainManager.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 18.05.2023.
//

import Foundation

class KeychainManager {

    enum KeychainErrorACAD: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }

    enum KeychainErrorAAPL: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }

    let server = "authenticationdemo-f852f.web.app"

    func saveCredentialsACAD(service: String, account: String, password: Data) throws {
        // service, account, password, class
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainErrorACAD.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainErrorACAD.unknown(status)
        }
    }

    func saveCredentialsAAPL(account: String, password: String) throws {
        let passwordData = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
            kSecAttrServer as String: server,
            kSecValueData as String: passwordData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainErrorAAPL.unhandledError(status: status)
        }
    }

    func getCredentialsACAD(service: String, account: String, password: Data) -> Data? {
        // service, account, class, return-data, matchlimit
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &result)

        return result as? Data
    }

    func getCredentialsAAPL() throws -> (username: String, password: String) {
        // service, account, password, class
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            throw KeychainErrorAAPL.noPassword
        }
        guard status == errSecSuccess else {
            throw KeychainErrorAAPL.unhandledError(status: status)
        }

        guard
            let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainErrorAAPL.unexpectedPasswordData
        }

        return (account, password)
    }
}
