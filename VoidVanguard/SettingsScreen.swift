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
    
    @State private var newEmail: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Image("Void")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.custom("Chalkduster", size: 50))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(60)
                
                Spacer()
                
                TextField("Enter new email", text: $newEmail)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                
                Button(action: {
                    Task {
                        do {
                            try await FireBaseAuth.shared.updateEmail(newEmail: newEmail)
                            alertMessage = "Verification email sent. Please verify the new email to complete the update!"
                        } catch {
                            alertMessage = "Failed to send verification: \(error.localizedDescription)"
                        }
                        showAlert = true
                    }
                }) {
                    Text("Change Email")
                }
                .padding()
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
            }
            .foregroundColor(.black)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Update Email"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    SettingsScreen()
}
