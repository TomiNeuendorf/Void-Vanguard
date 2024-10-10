//
//  FirestoreService.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 10.10.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    func saveHighScore(username: String,score : Int) async throws {
        guard let userId = FireBaseAuth.shared.user?.uid else {
            return
        }
        let highScore = HighScore(userID: userId,username: username, score: score)
        do {
            try Firestore.firestore().collection("Scores").document().setData(from: highScore)
        } catch {
            print("Error saving Score")
        }
    }
    
    func fetchScores() async throws -> [HighScore] {
        let snapshot = try await Firestore.firestore().collection("Scores").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: HighScore.self)
        }
    }
}
