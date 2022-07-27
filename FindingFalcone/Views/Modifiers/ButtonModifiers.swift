//
//  ButtonModifiers.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: Color.black.opacity(0.6), radius: 5, x: 5, y: 0)
    }
}
