//
//  RecordingBuffer.swift
//  visualizer
//
//  Created by John Yeung on 7/7/2022.
//
// an object storing the user recorded audio data

import Foundation

struct AudioRecording {
    var recordedAmplitude: Array<Double> = [] // the stored Amplitudes
    var timeCap: Int = -1 // the maximum size for the recorded amplitude, -1 means unlimited
    var isRecording: Bool=false
    
    mutating func addAmplitude(lastAmplitude: Double)->Void{ // return a boolean value to var isRecording, stop the recording if recordedAmplitude reached its max size
        if (self.isRecording){
            if ((self.timeCap == -1) || (self.recordedAmplitude.count < timeCap)){
                self.recordedAmplitude.append(lastAmplitude)
            } else{
                self.endRecording()
            }
        }
    }
    
    mutating func toggleRecording(){
        if (self.isRecording){
            self.endRecording()
        } else {
            self.startRecording()
        }
    }
    
    func getRecording()-> Array<Double>{
        return self.recordedAmplitude
    }
    
    mutating func startRecording(){
        self.isRecording = true
        self.recordedAmplitude = [] // reset the stored recording
    }
    
    mutating func endRecording(){
        self.isRecording = false
    }
    
    func getIsRecording()->Bool{
        return self.isRecording
    }
}

