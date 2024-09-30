import SwiftUI
import SpriteKit
import AVFoundation

struct SpaceBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        let scene = SKScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .resizeFill
        
        // Static space background
        let background = SKSpriteNode(imageNamed: "Void")
        background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        background.zPosition = -1
        
        // Adjust the scale to fit the entire screen
        let aspectRatio = background.size.width / background.size.height
        background.size = CGSize(width: scene.size.height * aspectRatio, height: scene.size.height)
        
        scene.addChild(background)
        view.presentScene(scene)
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}



struct HomeScreen: View {
    
    var body: some View {
        ZStack {
            // Hintergrundbild
            Image("Void")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Titel
                Text("Void Vanguard")
                    .font(.custom("Chalkduster", size: 40))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding()
                
                Spacer()
                // Start Game Button
                NavigationLink(destination: ContentView().navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                    Text("Start Game")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.bottom, 50)
                
                // Weitere Buttons
                HStack {
                    NavigationLink(destination: PlayerShipsScreen()) {
                        Text("Ships")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding()
                    
                    NavigationLink(destination: HighScoreScreen()) {
                        Text("High-Score")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding()
                    
                    NavigationLink(destination: SettingsScreen()) {
                        Text("Settings")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
