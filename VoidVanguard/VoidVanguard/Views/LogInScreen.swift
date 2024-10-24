//
//  LogInScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 26.09.24.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @State private var email =  ""
    @State private var password =  ""
    @State private var hasPressedSignUp = false
    @State private var hasPressedSignIn = false
    @State private var isPresentingError = false
    @State private var lastErrorMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            SpaceBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Login to Void Vanguard")
                    .font(.custom("PressStart2P-Regular", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)
                        .font(.headline)
                        .padding(.leading)
                    
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)
                        .font(.headline)
                        .padding(.leading)
                    
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
                
                Button(action: attemptSignIn) {
                    Text("Login")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(color: .purple, radius: 5)
                }
                .padding(.bottom, 50)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Failed"),
                        message: Text(lastErrorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: RegisterScreen()) {
                        Text("Sign Up")
                            .foregroundColor(.purple)
                            .bold()
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    func attemptSignIn() {
        Task {
            hasPressedSignIn = true
            do {
                try await FireBaseAuth.shared.signIn(email: email, password: password)
            } catch let error as NSError {
                // Spezifische Fehlermeldungen basierend auf Firebase Fehlercodes
                switch error.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    lastErrorMessage = "The email address is badly formatted."
                case AuthErrorCode.wrongPassword.rawValue:
                    lastErrorMessage = "The password is incorrect."
                case AuthErrorCode.userNotFound.rawValue:
                    lastErrorMessage = "No user found with this email."
                case AuthErrorCode.networkError.rawValue:
                    lastErrorMessage = "Network error. Please try again."
                case AuthErrorCode.userDisabled.rawValue:
                    lastErrorMessage = "This account has been disabled."
                default:
                    lastErrorMessage = "Email or Password incorrect "
                }
                showAlert = true
            }
            hasPressedSignIn = false
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
