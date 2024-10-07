//
//  FireBaseAuth.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 07.10.24.
//

import Foundation
import FirebaseAuth

@Observable
class FireBaseAuth {
    
    static let shared = FireBaseAuth()
   
    var user: User?
    
    var isUserSignedIn: Bool {
        user != nil
    }
    
    func signUp(email: String, password: String) async throws {
        let authResult = try await auth.createUser(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' is registered with id '\(authResult.user.uid)'")
        try await self.signIn(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' signed in with id '\(authResult.user.uid)'")
        self.user = authResult.user
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user = nil
            print("Sign out succeeded.")
        } catch let error as NSError {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
    
    init() {
        checkAuth()
    }
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("Not logged in")
            return
        }
        self.user = currentUser
    }
    
    private let auth = Auth.auth()
    
}

enum AuthError: LocalizedError {
    case noEmail
    
    var localizedDescription: String {
        switch self {
        case .noEmail:
            return "No email was found on newly created user."
        }
    }
}
