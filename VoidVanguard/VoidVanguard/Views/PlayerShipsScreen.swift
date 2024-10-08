//
//  PlayerShipsScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.
//

import SwiftUI

struct PlayerShipsScreen: View {
    let playerShips = ["ship_1", "ship_2", "ship_3", "ship_4","ship_5"]
    @State private var selectedShip: String = "ship_1" // Default ship
    
    var body: some View {
        ZStack {
            Image("Void") // Replace with your background image name
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("Choose Your Ship")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding()
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(playerShips, id: \.self) { ship in
                            Button(action: {
                                selectedShip = ship // Change ship
                            }) {
                                Image(ship)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .border(selectedShip == ship ? Color.blue : Color.clear, width: 3)
                            }
                            .padding()
                        }
                    }
                }
                
                // Show the selected ship
                Image(selectedShip)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                Spacer()
            }
            .foregroundColor(.white) // Text color
        }
    }
}

#Preview {
    PlayerShipsScreen()
}
