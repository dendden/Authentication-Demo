//
//  AuthService.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 15.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class AuthService {

    static let shared = AuthService()

    let firebaseAuth = Auth.auth()
    let firebaseBD = Firestore.firestore()

    private init() {}

    /// Registers a new user.
    /// - Parameter request: A request with user credentials.
    func registerUser(request: RegistrationRequest) async throws {
        let result = try await firebaseAuth.createUser(withEmail: request.email, password: request.password)

        try await firebaseBD.collection("users")
            .document(result.user.uid)
            .setData([
                "username": request.username,
                "email": request.email
            ])
    }

    func login(with request: LoginRequest) async throws {
        try await firebaseAuth.signIn(withEmail: request.email, password: request.password)
    }

    func logout() throws {
        try firebaseAuth.signOut()
    }
}
