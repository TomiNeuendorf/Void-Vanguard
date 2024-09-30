//
//  RegisterScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 26.09.24.
//

import SwiftUI

struct RegisterScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        ZStack {
            // Background: same space background as other screens
            SpaceBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Title
                Text("Register for Void Vanguard")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(.bottom, 30)
                
                // Email Input Field
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
                
                // Password Input Field
                VStack(alignment: .leading) {
                    Text("Password")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .font(.headline)
                        .padding(.leading)
                    
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                // Confirm Password Input Field
                VStack(alignment: .leading) {
                    Text("Confirm Password")
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .font(.headline)
                        .padding(.leading)
                    
                    SecureField("Confirm your password", text: $confirmPassword)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
                
                // Register Button
                Button(action: {
                }) {
                    Text("Register")
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
                
                // Login option for already registered users
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: LoginScreen()) {
                        Text("Login")
                            .foregroundColor(.purple)
                            .bold()
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
    }
}