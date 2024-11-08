//
//  HighScoreViewModel.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 10.10.24.
//

import Foundation
import Observation

@Observable
class HighScoreViewModel: ObservableObject {
    var highscores : [HighScore] = []
    
    
    func createHighscore(username: String,score: Int) async {
        
        do {
            try await FirestoreService.shared.saveHighScore(username: username, score: score)
        }catch {
            print("Error creating a Highscore \(error.localizedDescription)")
        }
        
    }
    
    func fetchHighscores() {
        Task {
            do {
                let fetchedHighscores = try await FirestoreService.shared.fetchScores()
                DispatchQueue.main.async {
                    self.highscores = fetchedHighscores
                }
            } catch {
                print("Error fetching threats: \(error)")
            }
        }
    }
    
    func deleteHighscore(score: HighScore) async {
        guard let documentID = score.id else {
            print("Fehler: Kein documentID vorhanden.")
            return
        }
        
        do {
            try await FirestoreService.shared.deleteHighscore(highscoreID: documentID)
            
            
            DispatchQueue.main.async {
                self.highscores.removeAll { $0.id == score.id }
            }
        } catch {
            print("Fehler beim Löschen des Highscores: \(error.localizedDescription)")
        }
    }
}

