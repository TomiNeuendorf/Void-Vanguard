//
//  SettingsScreen.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 19.09.24.
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
    let assetBackgrounds = ["Void", "background1", "background2", "background3", "background4", "background5"]
    
    // Default background
    let defaultBackgroundName = "Void"

    var body: some View {
        ZStack {
            // Use the selected background image or the default one
            if let image = settings.selectedBackgroundImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Image(defaultBackgroundName)
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
                                if let image = UIImage(named: backgroundName) {
                                    settings.selectedBackgroundImage = image
                                }
                            }) {
                                Image(backgroundName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.purple, lineWidth: 5)
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
                    .scaledToFit()
                }
                .background(Color.black.opacity(0.6))
                .cornerRadius(15)
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding()
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
                
                // Let the phone's buttons handle volume
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
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
