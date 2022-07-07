//
//  RecordingBuffer.swift
//  visualizer
//
//  Created by John Yeung on 7/7/2022.
//
// an object storing the user recorded audio data

import Foundation

struct AudioRecordings {
    var recordedAmplitude: Array<Double> = [] // the stored Amplitudes
    var timeCap: Int = -1 // the maximum size for the recorded amplitude, -1 means unlimited
    
    mutating func addAmplitude(lastAmplitude: Double)->Bool{ // return a boolean value to var isRecording, stop the recording if recordedAmplitude reached its max size
        if (self.timeCap > 0 && self.recordedAmplitude.count < timeCap){
            self.recordedAmplitude.append(lastAmplitude)
            return true
        } else{
            return false
        }
    }
    
    func getRecording()-> Array<Double>{
        return self.recordedAmplitude
    }
}

