//
//  CaptureTimeButton.swift
//  visualizer
//
//  Created by Mark Cheng on 16/4/2022.
//

import SwiftUI

struct CaptureTimeButton: View {
    let action: () -> Void
    let captureTime: Int
    var isRecording: Bool // sent from vm.audio.recording.isRecording

    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: "mic.fill")
                .font(.system(size: 18))
                .frame(width: 104)
                .padding(10)
                .foregroundColor(Color.neutral.onSurface)
                .background(self.isRecording ? Color(.systemRed) : Color.neutral.surface)
                .cornerRadius(20)
        }
    }
}

struct CaptureTimeButton_Previews: PreviewProvider {
    
    static func test() -> Void {
        print("Drawer Button Clicked")
    }

    static var previews: some View {
        VStack(){
            CaptureTimeButton(action:self.test, captureTime: 10, isRecording: false)
            CaptureTimeButton(action:self.test, captureTime: 10, isRecording: true)
        }
        
    }
}
