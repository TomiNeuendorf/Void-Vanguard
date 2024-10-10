import SwiftUI
import GameplayKit
import SpriteKit
import Combine
import Firebase
import FirebaseFirestore

// New GameState class to manage the gameOver state
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
                    ZStack{
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
                            }label: {
                                Text("Save your HighScore")
                            }
                            Button {
                                gameState.gameOver = false
                                dismiss()
                            }label: {
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
                    }.sheet(isPresented: $sheet, content: {
                        TextField("Enter your Username",text: $userName)
                        Button {
                            attemptSaveHighScore()
                            gameState.gameOver = false
                            dismiss()
                        }label: {
                            Text("Save")
                        }
                    })
                }
            }
        }
    }
    
    func configureScene() -> SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 750, height: 1335)
        scene.scaleMode = .aspectFill
        scene.gameState = gameState // Link the scene to the game state
        return scene
    }
    
    func attemptSaveHighScore () {

        Task{
            await viewModel.createHighscore(username:userName,score: gameState.score)
        }
    }
    
  
    
}

#Preview {
    ContentView()
    
}

