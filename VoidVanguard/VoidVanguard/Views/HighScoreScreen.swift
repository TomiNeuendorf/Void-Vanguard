//
//  HighScoreScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct UserScore: Identifiable {
    var id = UUID()
    var username: String
    var score: Int
}

struct HighScoreScreen: View {
    @State private var highScores: [UserScore] = []
    @State private var currentUserID: String? = nil
    @State private var currentUserHighScore: Int? = nil
    
    var body: some View {
        ZStack {
            SpaceBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                
                Text("High Scores")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(.bottom, 20)
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(highScores.sorted(by: { $0.score > $1.score })) { score in
                            HStack {
                                Text(score.username)
                                    .foregroundColor(score.username == "You" ? .green : .white) // Aktuellen Benutzer hervorheben
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
        .onAppear {
            fetchHighScores()
        }
        .navigationBarHidden(true)
    }
    
    
    func fetchHighScores() {
        guard let userID = FireBaseAuth.shared.user?.uid else {
            print("No User logged in")
            return
        }
        
        currentUserID = userID
        
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        
        usersRef.getDocuments { snapshot, error in
            if let error = error {
                print("Issue not getting a Highscore: \(error.localizedDescription)")
                return
            }
            
            if let documents = snapshot?.documents {
                var scores: [UserScore] = []
                for document in documents {
                    let data = document.data()
                    let username = data["username"] as? String ?? "Unknown Player"
                    let score = data["highScore"] as? Int ?? 0
                    let userID = document.documentID
                    
                    
                    let displayName = userID == FireBaseAuth.shared.user?.uid ? "You" : username
                    scores.append(UserScore(username: displayName, score: score))
                    
                    // Speichere den Highscore des aktuellen Benutzers
                    if userID == FireBaseAuth.shared.user?.uid {
                        self.currentUserHighScore = score
                    }
                }
                self.highScores = scores
            }
        }
    }
}

struct HighScoreScreen_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreScreen()
    }
}
