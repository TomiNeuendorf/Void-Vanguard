import SwiftUI
import GameplayKit
import SpriteKit
import Combine

// New GameState class to manage the gameOver state
class GameState: ObservableObject {
    @Published var gameOver = false
}

struct ContentView: View {
    
    @ObservedObject var gameState = GameState() // Using the GameState
    
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
                            NavigationLink {
                                HomeScreen()
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
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
}

#Preview {
    ContentView()
    
}

