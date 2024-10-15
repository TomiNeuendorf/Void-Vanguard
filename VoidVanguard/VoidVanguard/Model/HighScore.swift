//
//  HighScore.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 10.10.24.
//

import Foundation
import FirebaseFirestore

struct HighScore: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var userID: String
    var username: String
    var score: Int
}
