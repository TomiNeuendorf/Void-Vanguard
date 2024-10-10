//
//  HighScore.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 10.10.24.
//

import Foundation

struct HighScore: Identifiable, Codable, Hashable {
    var id = UUID()
    var userID : String
    var username: String
    var score: Int
}
