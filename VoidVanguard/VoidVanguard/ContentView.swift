import SwiftUI
import GameplayKit
import SpriteKit
import Combine

// New GameState class to manage the gameOver state
class GameState: ObservableObject {
    @Published var gameOver = false
}

struct ContentView: View {
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @ObservedObject var gameState = GameState() // Using the GameState
    
    var body: some View {
        NavigationView {
            ZStack {
                // Game Scene (SpriteKit view)
                SpriteView(scene: configureScene())
                    .ignoresSafeArea()
                
                // Game Over overlay
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
                                    .environmentObject(settingsViewModel)
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
    
    // Helper function to configure the scene
    func configureScene() -> SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 750, height: 1335)
        scene.scaleMode = .aspectFill
        scene.gameState = gameState // Link the scene to the game state
        return scene
    }
}

#Preview {
    ContentView().environmentObject(SettingsViewModel())
    
}

