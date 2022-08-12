//
//  RecordingBuffer.swift
//  visualizer
//
//  Created by John Yeung on 7/7/2022.
//
// an object storing the user recorded audio data
//
// USES:
//      addAmplitude() -------> endRecording()
//      toggleRecording()---/
//                      \------>startRecording()

import Foundation

struct AudioRecording {
    var recording: [RecordingData] = [] // the stored recording data, including Amplitudes, pitch frequency, pitch detune
    var splittedRecording: [[RecordingData]] = [[]]
    var splittedNoteIndices: [Int] = []
}

struct RecordingData {
    var amplitude: Double
    var pitchFrequency: Double
    var pitchDetune: Double
}
