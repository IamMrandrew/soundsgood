//
//  RecordingAnalytics.swift
//  visualizer
//
//  Created by Yeung on 14/7/2022.
//

import Foundation

struct RecordingAnalyticsDrawer: Codable {
    var selected: AnalyticsTypes
    
    static let `default` = RecordingAnalyticsDrawer(
        selected: .notes
    )
    
    enum AnalyticsTypes: String, Identifiable, Codable {
        case notes
        case melody
        
        var id: String { rawValue }
        
        var label: String {
            switch self {
            case .notes: return "Notes"
            case .melody: return "Melody"
            }
          }
        
        var icon: String {
            switch self {
            case .notes: return "Notes"
            case .melody: return "Melody"
            }
        }
    }
}
