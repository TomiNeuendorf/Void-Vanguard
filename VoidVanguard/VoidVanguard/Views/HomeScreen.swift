import SwiftUI
import SpriteKit

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

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 5)
            )
            .foregroundColor(.white)
            .shadow(color: .purple, radius: configuration.isPressed ? 10 : 5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct HomeScreen: View {
    @EnvironmentObject var settings: SettingsViewModel
    
    var body: some View {
        ZStack {
            // Use the selected background image
            if let image = settings.selectedBackgroundImage {
                Image(uiImage:image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            VStack {
                // Title
                Text("Void Vanguard")
                    .font(.custom("Chalkduster", size: 40))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding()
                
                Spacer()
                
                // Start Game button
                NavigationLink(destination: ContentView().navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                    Text("Start Game")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.bottom, 50)
                
                HStack {
                    Button("Ships") {
                        // Add action for Ships
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding()
                    
                    Button("H-Scores") {
                        // Add action for HighScores
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding()
                    
                    NavigationLink(destination: SettingsScreen()
                        .environmentObject(settings)
                    ) {
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
    NavigationStack{
        HomeScreen()
            .environmentObject(SettingsViewModel())
    }
    
    
}

