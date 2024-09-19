//
//  SettingsViewModel.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.
//

import AVFoundation
import UIKit

class SettingsViewModel: ObservableObject {
    @Published var selectedBackgroundImage: UIImage?
    @Published var musicVolume: Float = 0.5 {
        didSet {
            audioPlayer?.volume = musicVolume
        }
    }
    
    private var audioPlayer: AVAudioPlayer?

    init() {
        playMusic()
    }

    // Play background music
    func playMusic() {
        if let musicUrl = Bundle.main.url(forResource: "naruto_the-raising-fighting-spirit", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicUrl)
                audioPlayer?.volume = musicVolume
                audioPlayer?.numberOfLoops = -1 // Loop infinitely
                audioPlayer?.play()
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        } else {
            print("Background music file not found.")
        }
    }

    // Pause the music
    func pauseMusic() {
        audioPlayer?.pause()
    }

    // Resume the music
    func resumeMusic() {
        audioPlayer?.play()
    }

    // Stop the music
    func stopMusic() {
        audioPlayer?.stop()
    }
}
