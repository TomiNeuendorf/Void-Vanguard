//
//  HomeScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 11.09.24.
//

import SwiftUI
import SpriteKit

struct HomeScreen: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    Text("Void Vanguard")
                        .font(.custom("Chalkduster", size: 45))
                        .fontWeight(.bold)
                    
                    Spacer()
                    NavigationLink{
                        ContentView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Start Game")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text("Ships")
                        }
                        .padding()
                        
                        Button {
                            
                        } label: {
                            Text("HighScores")
                        }
                        .padding()
                        
                        Button {
                            
                        } label: {
                            Text("Settings")
                        }
                        .padding()
                        
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
