//
//  PitchNotation.swift
//  visualizer
//
//  Created by Andrew Li on 20/11/2021.
//

import Foundation

let A4: Float = 440
let C0: Float = A4 * pow(2, -4.75)

// TODO: Notation for different Key
let notationSharp = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
let notationFlat = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

func pitchFromFrequency(_ frequency: Float, _ noteRepresentation: Setting.NoteRepresentation) -> String {
    if (frequency > C0) {
        let steps: Int = Int(round(12 * log2(frequency / C0)))   // Number of semitone from C0 to frequency
        let octave = steps / 12
        let n = steps % 12
        
        return noteRepresentation == Setting.NoteRepresentation.sharp ? notationSharp[n] + String(octave) : notationFlat[n] + String(octave)
    } else {
        return "-"
    }
}

func mapNearestFrequency(_ frequency: Float) -> Float {
    if (frequency > C0) {
        let steps: Int = Int(round(12 * log2(frequency / C0)))   // Number of semitone from C0 to frequency
        let nearestNoteFrequency =  pow(2, Float(steps) / 12) * C0
        
        return nearestNoteFrequency
    } else {
        return 0
    }
}

func pitchDetuneFromFrequency(_ frequency: Float) -> Float {
    if (frequency > C0) {
        let steps: Int = Int(round(12 * log2(frequency / C0)))   // Number of semitone from C0 to frequency
        
        let nearestNoteFrequency =  pow(2, Float(steps) / 12) * C0
        let nearestHigherNoteFrequency =  pow(2, Float(steps + 1) / 12) * C0
        let nearestLowerNoteFrequency =  pow(2, Float(steps - 1) / 12) * C0
        
        let sharp = frequency > nearestNoteFrequency
        let flat = frequency < nearestNoteFrequency
        
        if (sharp) {
            let cent = (nearestHigherNoteFrequency - nearestNoteFrequency) / 100
            return (frequency - nearestNoteFrequency) / cent
        } else if (flat) {
            let cent = (nearestNoteFrequency - nearestLowerNoteFrequency) / 100
            return -((nearestNoteFrequency - frequency) / cent)
        }
        
        return nearestNoteFrequency
    } else {
        return 0
    }
    
}

func changePitchNotation(_ pitchLetter: String) -> String {
    let letter = String(pitchLetter.dropLast())
    let octave = String(pitchLetter.suffix(1))
    if (notationFlat.contains(letter)) {
        if let index = notationFlat.firstIndex(where: {$0 == letter}) {
            return notationSharp[index] + octave
        } else {
            return "-"
        }
    } else {
        if let index = notationSharp.firstIndex(where: {$0 == letter}) {
            return notationFlat[index] + octave
        } else {
            return "-"
        }
    }
}

func getLabeling(_ interval: Int)->[Int] {
    var l:[Int] = []
    for i in 0..<25 {
        l.append(i*interval)
    }
    return l
}

func getSurroundingLetters(_ pitchNotation: String) -> Array<String> {
    let pitchLetter = String(pitchNotation.dropLast())
    if let i = notationSharp.firstIndex(of: pitchLetter) {
        return [notationSharp[circular: i+1] + pitchNotation.suffix(1), pitchLetter + pitchNotation.suffix(1), notationSharp[circular: i-1] + pitchNotation.suffix(1)]
    }else if let i = notationFlat.firstIndex(of: pitchLetter){
        return [notationFlat[circular: i+1] + pitchNotation.suffix(1), pitchLetter + pitchNotation.suffix(1), notationFlat[circular: i-1] + pitchNotation.suffix(1)]
    }else {
        return ["-", "-", "-"]
    }
}
