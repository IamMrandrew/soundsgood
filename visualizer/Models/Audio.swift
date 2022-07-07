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
    var recording: AudioRecording
    var peakBarIndex: Int
    var pitchNotation: String
    var pitchFrequency: Float
    var pitchDetune: Float
    var isPitchAccurate: Bool
    let totalHarmonics: Int
    var harmonicAmplitudes: [Double]
    var audioFeatures: AudioFeatures
    var lastAmplitude: Double
    var captureTime: Int
    
    
    
    static let `default` = Audio(
        amplitudes: Array(repeating: 0.5, count: 256),
        amplitudesToDisplay: Array(repeating: 0.5, count: 256),
        recording: AudioRecording(recordedAmplitude:[], timeCap:-1),
        peakBarIndex: -1,
        pitchNotation: "-",
        pitchFrequency: 0.0,
        pitchDetune: 0.0,
        isPitchAccurate: false,
        totalHarmonics: 12,
        harmonicAmplitudes: Array(repeating: 0.5, count: 12),
        audioFeatures: AudioFeatures(spectralCentroid: 0, inharmonicity: 0, quality: 0),
        lastAmplitude: 0,
        captureTime: 10 // now fixed as 10
    )
}

struct AudioFeatures {
    var spectralCentroid: Double
    var inharmonicity: Double
    var quality: Double
}

enum AudioFeature: String, CaseIterable, Identifiable, Codable {
    case spectralCentroid = "Brightness"
    case quality = "Fullness"
    
    var id: String { rawValue }
    
    func getDescription () -> String {
        switch self {
        case .spectralCentroid:
            return "Brightness describes how bright or warm you sounds"
        case .quality:
            return "Fullness describes how full or hollow you sounds"
        }
    }
    
    func getLabels () -> (String, String) {
        switch self {
        case .spectralCentroid:
            return ("Dark/warm", "Bright")
        case .quality:
            return ("Hollow", "Full")
        }
        
    }
}
