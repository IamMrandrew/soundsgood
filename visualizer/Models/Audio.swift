//
//  Audio.swift
//  visualizer
//
//  Created by Andrew Li on 5/2/2022.
//

import Foundation

struct Audio {
    var amplitudes: [Double] // realtime amplitudes
    var amplitudesToDisplay: [Double] // amplitudes on change by some event(e.g., pitch change)
    var peakBarIndex: Int
    var pitchNotation: String
    var pitchFrequency: Float
    var pitchDetune: Float
    var isPitchAccurate: Bool
    let totalHarmonics: Int
    var harmonicAmplitudes: [Double]
    var captureTime: Int
    
    
    
    
    static let `default` = Audio(
        amplitudes: Array(repeating: 0.5, count: 256),
        amplitudesToDisplay: Array(repeating: 0.5, count: 256),
        peakBarIndex: -1,
        pitchNotation: "-",
        pitchFrequency: 0.0,
        pitchDetune: 0.0,
        isPitchAccurate: false,
        totalHarmonics: 12,
        harmonicAmplitudes: Array(repeating: 0.5, count: 12),
        captureTime: 2
    )
}
