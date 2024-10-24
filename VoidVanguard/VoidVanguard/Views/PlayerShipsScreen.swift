//
//  PlayerShipsScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.
//

import SwiftUI
import FirebaseFirestore

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
                    .font(.custom("PressStart2P-Regular", size: 35))
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
                Spacer()
                
                Image(selectedShip)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
               
                Spacer()
                
                Button {
                    saveSelectedShip(ship: selectedShip)
                }label: {
                    Text("Save")
                }
                .buttonStyle(CustomButtonStyle())
                
                Spacer()
            }
            .foregroundColor(.white) // Text color
        }
    }
    
    func saveSelectedShip(ship: String) {
        let db = Firestore.firestore()
        guard let userId = FireBaseAuth.shared.user?.uid else {
            return
        }
        db.collection("users").document(userId).setData(["selectedShip": ship], merge: true) { error in
            if let error = error {
                print("Fehler beim Speichern des Schiffs: \(error.localizedDescription)")
            } else {
                print("Schiff erfolgreich gespeichert.")
            }
        }
    }
}

#Preview {
    PlayerShipsScreen()
}
