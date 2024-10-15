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
    
    func saveHighScore(username: String, score: Int) async throws {
        guard let userId = FireBaseAuth.shared.user?.uid else {
            return
        }
        
      
        let highScoreID = UUID().uuidString //
        let highScore = HighScore(id:highScoreID, userID: userId, username: username, score: score)
        
        
        do {
            try Firestore.firestore()
                .collection("Scores")
                .document(highScoreID)
                .setData(from: highScore)
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
    
    func loadSelectedShip() async throws -> String? {
        let db = Firestore.firestore()
        guard let userId = FireBaseAuth.shared.user?.uid else {
            throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User ist nicht angemeldet."])
        }
        
        let document = try await db.collection("users").document(userId).getDocument()
        if document.exists, let data = document.data(), let selectedShip = data["selectedShip"] as? String {
           print(selectedShip)
            return selectedShip
        } else {
            return nil 
        }
    }
    
    func deleteHighscore(highscoreID: String) async throws {
          let db = Firestore.firestore()
          
          do {
              try await db.collection("Scores").document(highscoreID).delete()
              print("Highscore erfolgreich gelöscht.")
          } catch {
              print("Fehler beim Löschen des Highscores: \(error.localizedDescription)")
              throw error
          }
      }
  }


enum DataError: LocalizedError {
  case failedSaving
  case noDocumentID
  var errorDescription: String {
    switch self {
    case .failedSaving:
      "Could not persist the item"
    case .noDocumentID:
      "Didn't find a document ID"
    }
  }
}
