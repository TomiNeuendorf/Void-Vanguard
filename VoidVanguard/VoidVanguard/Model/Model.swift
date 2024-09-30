//
//  Model.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 27.09.24.
//

struct Quote: Codable, Identifiable {
    let id: Int
    let quote, character, title, esrb: String
    let release: Int
}
