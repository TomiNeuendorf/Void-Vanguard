//
//  VoidVanguardApp.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 09.09.24.
//

import SwiftUI
import Firebase

@main
struct VoidVanguardApp: App {
    var body: some Scene {
        WindowGroup {
            if FireBaseAuth.shared.isUserSignedIn{
                HomeScreen()
            }else {
                OnboardingScreen()
            }
        }
    }
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
}

