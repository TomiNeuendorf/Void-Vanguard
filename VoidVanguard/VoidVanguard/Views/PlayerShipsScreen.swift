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
    @Environment(\.presentationMode) var presentationMode // For the back action

    var body: some View {
        ZStack {
            // Background
            Image("Void") // Replace with your background image name
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    // Back option
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                        }
                    Spacer()
                }
                .padding()

                Text("Choose Your Ship")
                    .font(.custom("Chalkduster", size: 35))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding()
                
                Spacer()

                // Show all ships in a ScrollView
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
                                    .border(selectedShip == ship ? Color.blue : Color.clear, width: 3) // Highlight selected ship
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
