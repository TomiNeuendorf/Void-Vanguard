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
    @ObservedObject var quoteViewModel = QuoteViewModel()
    
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
                
                // ScrollView für Quotes mit Rahmen/Box
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(quoteViewModel.quotes) { quote in
                            VStack {
                                Text(quote.quote)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 5)
                                
                                Text("- \(quote.character)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                Color.black.opacity(0.3) // Hintergrundfarbe der Box
                            )
                            .cornerRadius(10) // Optional: Leicht abgerundete Ecken
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple, lineWidth: 2) // Rahmen um die Box
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(height: 300) // Höhe für den scrollbaren Bereich
                .padding(.bottom, 20)
                
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
