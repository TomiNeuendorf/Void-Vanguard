//
//  SettingsViewModel.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 18.09.24.
//

import SwiftUI
import UIKit

class SettingsViewModel: ObservableObject {
    @Published var selectedBackgroundImage: UIImage? = UIImage(named: "Void") // Default image
}

