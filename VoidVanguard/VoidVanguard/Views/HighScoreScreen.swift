//
//  HighScoreScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.
//
import SwiftUI

// Sample data structure for High Scores
struct UserScore: Identifiable {
    var id = UUID()
    var username: String
    var score: Int
}

struct HighScoreScreen: View {
    // Sample high scores
    let scores: [UserScore] = [
        UserScore(username: "HomelessEmperor",score: 20000),
        UserScore(username: "CommanderZ", score: 10000),
        UserScore(username: "StarGazer", score: 8500),
        UserScore(username: "VoidMaster", score: 7500),
        UserScore(username: "GalaxyHunter", score: 6500),
        UserScore(username: "NebulaWarrior", score: 5000),
        UserScore(username: "MoeTheHoe",score: 2000),
        UserScore(username:"Benjamin Blümchen",score: 1000)
    ]
    
    var body: some View {
        ZStack {
            // Background
            SpaceBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Title
                Text("High Scores")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(.bottom, 20)

                // High Score List
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(scores) { score in
                            HStack {
                                Text(score.username)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.leading)
                                
                                Spacer()
                                
                                Text("\(score.score)")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.trailing)
                            }
                            .padding()
                            .background(Color.purple.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(color: .purple, radius: 5)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct HighScoreScreen_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreScreen()
    }
}

