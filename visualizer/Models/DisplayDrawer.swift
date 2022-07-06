//
//  DisplayDrawer.swift
//  visualizer
//
//  Created by John Yeung on 6/7/2022.
//
// A Drawer class storing the Display type information
// Selection can be modified through the DisplayDrawer pop up menu.

import Foundation

struct DisplayDrawer: Codable {
    var selected: DisplayTypes
    
    static let `default` = DisplayDrawer(
        selected: .musicalNotes
    )
    
    enum DisplayTypes: String, Identifiable, Codable {
        case musicalNotes
        case dynamic
        case xxx
        case none
        
        var id: String { rawValue }
        
        var label: String {
            switch self {
            case .musicalNotes: return "Musical notes"
            case .dynamic: return "Dynamic"
            case .xxx: return "xxx"
            case .none: return "None"
            }
          }
        
        var icon: String {
            switch self {
            case .musicalNotes: return "Musical notes"
            case .dynamic: return "Dynamic"
            case .xxx: return "xxx"
            case .none: return "None"
            }
        }
    }
}
