import SwiftUI
import UIKit

struct SettingsScreen: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
            }
        }
    }
    
    var body: some View {
        ZStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Image("Void") // Default background image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 20){
                Text("Settings")
                    .font(.custom("Chalkduster", size: 50))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding()
                    .padding(80)
                
                Button(action: {
                }) {
                    Text("Change Password")
                }
                .padding()
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Change Email")
                }
                .padding()
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
            }
            .foregroundColor(.white) // Make text white for better visibility
        }
    }
}
#Preview {
    SettingsScreen()
}
