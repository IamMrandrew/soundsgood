//
//  DIsplayDrawerViewModel.swift
//  visualizer
//
//  Created by John Yeung on 29/6/2022.
//

import Foundation

class DisplayDrawerViewModel: ObservableObject {
    @Published var displayDrawer: DisplayDrawer
    
    init() {
        self.displayDrawer = DisplayDrawer.default
    }
    
    func isSelected(_ type: DisplayDrawer.DisplayTypes) -> Bool {
        return type == self.displayDrawer.selected
    }
}
