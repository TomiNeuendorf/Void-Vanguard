//
//  LogInScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 26.09.24.
//

import SwiftUI

struct LoginScreen: View {
    @State private var email =  ""
    @State private var password =  ""
    @State private var hasPressedSignUp = false
    @State private var hasPressedSignIn = false
    @State private var isPresentingError = false
    @State private var lastErrorMessage = ""
    
    
    var body: some View {
        ZStack {
            SpaceBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                
                Text("Login to Void Vanguard")
                    .font(.custom("Chalkduster", size: 35))
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
                
                
                Button(action:attemptSignIn) {
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
            } catch {
                lastErrorMessage = error.localizedDescription
                isPresentingError = true
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

