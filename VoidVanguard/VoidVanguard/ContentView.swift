import SwiftUI
import GameplayKit
import SpriteKit
import Combine
import Firebase
import FirebaseFirestore

class GameState: ObservableObject {
    @Published var gameOver = false
    @Published var score = 0
    
    
}

struct ContentView: View {
    @State var userName = ""
    @State var sheet = false
    
    @ObservedObject var gameState = GameState() // Using the GameState
    @Environment(\.dismiss) private var dismiss
    
    private var viewModel = HighScoreViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: configureScene())
                    .ignoresSafeArea()
                
                if gameState.gameOver {
                    ZStack {
                        Color.myPurple
                            .ignoresSafeArea()
                        Image("GameOver")
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            Button {
                                sheet.toggle()
                            } label: {
                                Text("Save your HighScore")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            }
                            Button {
                                gameState.gameOver = false
                                dismiss()
                            } label: {
                                Text("Back To Start")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    .sheet(isPresented: $sheet) {
                        ZStack {
                            Color.myPurple 
                                .ignoresSafeArea()
                            VStack(spacing: 20) {
                                Text("Enter your Username")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                TextField("Username", text: $userName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                
                                Button {
                                    attemptSaveHighScore()
                                    gameState.gameOver = false
                                    dismiss()
                                } label: {
                                    Text("Save")
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                            .padding()
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
    
    func configureScene() -> SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 750, height: 1335)
        scene.scaleMode = .aspectFill
        scene.gameState = gameState
        return scene
    }
    
    func attemptSaveHighScore() {
        Task {
            await viewModel.createHighscore(username: userName, score: gameState.score)
        }
    }
}

#Preview {
    ContentView()
}
