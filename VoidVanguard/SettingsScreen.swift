import SwiftUI
import UIKit
import FirebaseAuth

struct SettingsScreen: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    
    @State private var newEmail: String = ""
    @State private var currentEmail: String = ""  // Aktuelle E-Mail-Adresse
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
                    .font(.custom("PressStart2P-Regular", size: 38))
                    .foregroundColor(.white)
                    .shadow(color:.purple, radius: 5)
                    .padding(60)
                
                Spacer()
                
                // Anzeige der aktuellen E-Mail-Adresse in einer Box
                VStack(alignment: .leading) {
                Text(currentEmail)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .shadow(color: .myPurple, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                // Eingabefeld für neue E-Mail
                TextField("Enter new email", text: $newEmail)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                
                // Button zum Ändern der E-Mail
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
            .onAppear {
                loadCurrentEmail()
            }
        }
    }
    
    // Funktion zum Abrufen der aktuellen E-Mail-Adresse
    func loadCurrentEmail() {
        if let user = Auth.auth().currentUser {
            currentEmail = user.email ?? "No email found"
        }
    }
}

#Preview {
    SettingsScreen()
}
