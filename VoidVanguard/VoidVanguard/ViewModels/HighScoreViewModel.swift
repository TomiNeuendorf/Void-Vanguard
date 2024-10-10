//
//  HighScoreViewModel.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 10.10.24.
//

import Foundation
import Observation

@Observable
class HighScoreViewModel {
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
    
}

