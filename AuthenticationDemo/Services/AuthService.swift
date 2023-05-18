//
//  AuthService.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 15.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

enum FirebaseDocumentKeys {
    static let username = "username"
    static let email = "email"
}

class AuthService {

    static let shared = AuthService()

    let firebaseAuth = Auth.auth()
    let firebaseDB = Firestore.firestore()

    private init() {}

    /// Registers a new user.
    /// - Parameter request: A request with user credentials.
    func registerUser(request: RegistrationRequest) async throws {
        let result = try await firebaseAuth.createUser(withEmail: request.email, password: request.password)

        try await firebaseDB.collection("users")
            .document(result.user.uid)
            .setData([
                FirebaseDocumentKeys.username: request.username,
                FirebaseDocumentKeys.email: request.email
            ])
    }

    func login(with request: LoginRequest) async throws {
        try await firebaseAuth.signIn(withEmail: request.email, password: request.password)
    }

    func logout() throws {
        try firebaseAuth.signOut()
    }

    func forgotPassword(for email: String) async throws {
        try await firebaseAuth.sendPasswordReset(withEmail: email)
    }

    func fetchUser() async throws -> User {
        guard let uid = firebaseAuth.currentUser?.uid else {
            throw URLError(.badServerResponse)
        }

        let userSnapshot = try await firebaseDB
            .collection("users")
            .document(uid)
            .getDocument()

        guard
            let userData = userSnapshot.data(),
            let username = userData[FirebaseDocumentKeys.username] as? String,
            let email = userData[FirebaseDocumentKeys.email] as? String
        else {
            throw URLError(.cannotCreateFile)
        }

        return User(username: username, email: email, uid: uid)
    }
}
