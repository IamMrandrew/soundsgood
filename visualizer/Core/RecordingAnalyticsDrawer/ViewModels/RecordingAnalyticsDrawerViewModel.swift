//
//  RecordingAnalyticsDrawerViewModel.swift
//  visualizer
//
//  Created by Yeung on 13/7/2022.
//

import Foundation

class RecordingAnalyticsDrawerViewModel: ObservableObject {
    @Published var recordingAnalyticsDrawer: RecordingAnalyticsDrawer

    init() {
        self.recordingAnalyticsDrawer = RecordingAnalyticsDrawer.default
    }

    func isSelected(_ type: RecordingAnalyticsDrawer.AnalyticsTypes) -> Bool {
        return type == self.recordingAnalyticsDrawer.selected
    }
    
}
