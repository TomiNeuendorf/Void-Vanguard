//
//  CustomButtonStyle.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 20.09.24.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 5)
            )
            .foregroundColor(.white)
            .shadow(color: .purple, radius: configuration.isPressed ? 10 : 5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
