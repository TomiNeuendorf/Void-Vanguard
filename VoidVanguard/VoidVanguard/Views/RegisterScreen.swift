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
                
                Text("Register for Void Vanguard")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(.bottom, 30)
                
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
                
                Button(action: {
                    if password == confirmPassword {
                        Task {
                            do{
                                try await FireBaseAuth.shared.signUp(email: email, password: password)
                            }catch {
                                print("Error signing up \(error)")
                            }
                        }
                    }else {
                        print("Passwords to not Match")
                    }
                }){
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
    
    func attemptSignUp() {
        Task {
            hasPressedSignUp = true
            do {
                try await FireBaseAuth.shared.signUp(email: email, password: password)
            } catch {
                lastErrorMessage = error.localizedDescription
                isPresentingError = true
            }
            hasPressedSignUp = false
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
    }
}
