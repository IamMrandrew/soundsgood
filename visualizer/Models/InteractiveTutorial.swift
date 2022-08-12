//
//  InteractiveTutorial.swift
//  visualizer
//
//  Created by Andrew Li on 22/1/2022.
//

import Foundation
import SwiftUI

struct InteractiveTutorial {
    var text: String
    var textPosition: CGSize
    
    var size: CGSize
    var offset: CGSize
    
    enum Page: String {
        case pitch = "pitch"
        case timbre = "timbre"
        case sound = "sound"
    }
}


