//
//  SettingsScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 17.09.24.
//

import SwiftUI
import SpriteKit
import AVFoundation
import UIKit

struct SettingsScreen: View {
    @EnvironmentObject var settings: SettingsViewModel
    @State private var isImagePickerPresented = false
    @State private var audioPlayer: AVAudioPlayer?
    
    // Array of asset background names
    let assetBackgrounds = ["Void", "background1","background2","background3","background4", "background5"]

    var body: some View {
        ZStack {
            // Use the selected background image
            if let image = settings.selectedBackgroundImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }

            VStack {
                // Title
                Text("Settings")
                    .font(.custom("Chalkduster", size: 40))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 5)
                    .padding(.top, 50)

                Spacer()

                // Horizontal Scroll View for asset backgrounds
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(assetBackgrounds, id: \.self) { backgroundName in
                            Button(action: {
                                // Check if the image exists in assets and apply it as the selected background
                                if let image = UIImage(named: backgroundName) {
                                    settings.selectedBackgroundImage = image
                                }
                            }) {
                                Image(backgroundName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding()
                }

                // Change Background Button (for custom image picker)
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Change Background (Custom)")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.bottom, 30)
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $settings.selectedBackgroundImage)
                }

                // Music Volume Slider
                VStack {
                    Text("Music Volume")
                        .font(.headline)
                        .foregroundColor(.white)
                    Slider(value: Binding(get: {
                        Double(settings.musicVolume)
                    }, set: { newValue in
                        settings.musicVolume = Float(newValue)
                        audioPlayer?.volume = settings.musicVolume
                    }), in: 0...1)
                    .padding()
                }
                .background(Color.black.opacity(0.6))
                .cornerRadius(15)
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            playMusic()
        }
    }

    // Play background music
    func playMusic() {
        if let musicUrl = Bundle.main.url(forResource: "naruto_the-raising-fighting-spirit", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicUrl)
                audioPlayer?.volume = settings.musicVolume
                audioPlayer?.play()
                audioPlayer?.numberOfLoops = -1 // Loop infinitely
            } catch {
                print("Error playing music: \(error)")
            }
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of SettingsViewModel for preview
        SettingsScreen()
            .environmentObject(SettingsViewModel())
    }
}
