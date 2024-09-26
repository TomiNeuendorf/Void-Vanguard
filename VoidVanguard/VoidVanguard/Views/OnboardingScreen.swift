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
        ZStack {
            // Static background image from the SKSpriteNode scene
            SpaceBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()

                // Title
                Text("Welcome to Void Vanguard")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5)
                    .padding(.bottom, 20)
                Spacer()
                // Description
                Text("Conquer the Galaxy and protect your fleet!")
                    .font(.custom("Chalkduster",size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Next or Start Button
                Button(action: {
                    // Action to move to the next screen, i.e., start the game or go to home screen
                }) {
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

#Preview {
    NavigationStack {
        OnboardingScreen()
    }
}
