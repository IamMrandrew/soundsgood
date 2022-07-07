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
            if (self.isRecording){
                Image(systemName: "mic.fill")
                    .frame(width: 96, height: 48)
                    .foregroundColor(Color(.systemRed))
                    .background(Color.neutral.surface)
                    .clipShape(Rectangle())
                    .font(.system(size: 22))
            } else{
                Image(systemName: "mic.fill")
                    .frame(width: 96, height: 48)
                    .foregroundColor(.neutral.onSurface)
                    .background(Color.neutral.surface)
                    .clipShape(Rectangle())
                    .font(.system(size: 22))
            }
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
