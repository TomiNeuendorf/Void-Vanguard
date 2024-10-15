//
//  HighScoreScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HighScoreScreen: View {
    @StateObject private var viewModel = HighScoreViewModel() // Verwende @StateObject

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
                    ForEach(viewModel.highscores) { score in
                        HStack {
                            Text(score.username)
                                .font(.headline)
                                .padding(.leading)

                            Spacer()

                            Text("\(score.score)")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.trailing)
                            
                            // Löschen-Button hinzufügen
                            Button(action: {
                                Task {
                                    await viewModel.deleteHighscore(score: score)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(.trailing, 10)
                            }
                        }
                        .padding()
                        .background(Color.purple.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(color: .purple, radius: 5)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)

                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchHighscores()
        }
    }
}

struct HighScoreScreen_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreScreen()
    }
}
