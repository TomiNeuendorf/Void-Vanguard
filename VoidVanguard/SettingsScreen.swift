import SwiftUI
import UIKit

struct SettingsScreen: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                // Update ViewModel's image (if needed)
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background Image Handling
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
                // Change Password and Change Email buttons
                    .padding(80)
                
                Button(action: {
                    // Action for Change Password
                }) {
                    Text("Change Password")
                }
                .padding()
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
                
                Button(action: {
                    // Action for Change Email
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
