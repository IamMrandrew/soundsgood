//
//  VPitchIndicator.swift
//  visualizer
//
//  Created by Mark Cheng on 6/4/2022.
//

import SwiftUI

struct VPitchIndicator: View {
    @Binding var pitchLetter: String
    var position: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.foundation.primary)
            .opacity(0.85)
            .frame(maxWidth: 51, maxHeight: 442)
            .cornerRadius(15)
            .overlay(
                VStack {
                    Text(getSurroundingLetters(pitchLetter)[0])
                        .font(.heading.large)
                        .foregroundColor(.foundation.secondary)
                    Dot(isLarge: position == 0 || position == 1)
                    Dot(isLarge: position == 2 || position == 3)
                    Text(getSurroundingLetters(pitchLetter)[1])
                        .font(.heading.large)
                        .foregroundColor(.foundation.onPrimary)
                    Dot(isLarge: position == 5 || position == 6)
                    Dot(isLarge: position == 7 || position == 8)
                    Text(getSurroundingLetters(pitchLetter)[2])
                        .font(.heading.large)
                        .foregroundColor(.foundation.secondary)
                }
            )
    }
}

struct Dot: View {
    var isLarge: Bool
    
    var body: some View {
        if (isLarge) {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.foundation.onPrimary)
                .padding(5)
        } else {
            Circle()
                .frame(width: 5, height: 5)
                .foregroundColor(.foundation.secondary)
                .padding(10)
        }
    }
}

struct VPitchIndicator_Previews: PreviewProvider {
    @State static private var pitchLetter = "C"
//    static private var pitchLetters = getSurroundingLetters("-")
    
    static var previews: some View {
        VPitchIndicator(pitchLetter: $pitchLetter, position: 2)
    }
}

