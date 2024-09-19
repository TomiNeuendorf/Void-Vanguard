//
//  VoidVanguardApp.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 09.09.24.
//

import SwiftUI

@main
struct VoidVanguardApp: App {
    @StateObject var settings = SettingsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}

