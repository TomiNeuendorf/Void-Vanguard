//
//  OnboardingScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 26.09.24.
//

import SwiftUI
import SpriteKit

struct OnboardingScreen: View {
    var body: some View {
        NavigationStack{
            ZStack {
                SpaceBackground()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Welcome to Void Vanguard")
                        .font(.custom("Chalkduster", size: 35))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                        .padding(.bottom, 20)
                    Spacer()
                    
                    Text("Conquer the Galaxy and protect your fleet!")
                        .font(.custom("Chalkduster",size: 35))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginScreen()) {
                        Text("Get Started")
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
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingScreen()
    }
}
