//
//  RecordingAnalyticsDrawerView.swift
//  visualizer
//
//  Created by Yeung on 13/7/2022.
//

import Foundation
import SwiftUI

struct RecordingAnalyticsDrawerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var recordingAnalyticsDrawerVM: RecordingAnalyticsDrawerViewModel
    @EnvironmentObject var audioVM: AudioViewModel
    @Binding var isShowing: Bool
    
    @State private var analyticsMode: RecordingAnalyticsDrawer.AnalyticsTypes = .notes
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 8)
            
            HStack(alignment: .center) {
                Spacer()
                
                Text("Analytics")
                    .font(.heading.small)
                
                Spacer()
                    .overlay(
                        DismissButton(action: { presentationMode.wrappedValue.dismiss() }),
                        alignment: .trailing
                    )
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 32)
       
            HStack(){
                Spacer()
                Picker("Analysis Mode", selection: $analyticsMode) {
                    Text(RecordingAnalyticsDrawer.AnalyticsTypes.notes.label)
                        .tag(RecordingAnalyticsDrawer.AnalyticsTypes.notes)
                    Text(RecordingAnalyticsDrawer.AnalyticsTypes.melody.label)
                        .tag(RecordingAnalyticsDrawer.AnalyticsTypes.melody)
                }
                .pickerStyle(.segmented)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 24))
        .foregroundColor(.neutral.onBackground)
         
        Amplitudes()
            
        VStack(alignment: .leading) {
            switch analyticsMode {
            case .notes:
                AnalyticsChart(title: "Dynamic", descriptiveText: "How consistent your dyanmic is", data: audioVM.audio.recording.recordedAmplitude)
                AnalyticsChart(title: "Accuracy", descriptiveText: "How many percent you are in tune", data: audioVM.audio.recording.recordedAmplitude)
            case .melody:
                AnalyticsChart(title: "Dynamic", descriptiveText: "Attack, Sustain, Release, Decay", data: audioVM.audio.recording.recordedAmplitude)
                AnalyticsChart(title: "Accuracy", descriptiveText: "How your pitch change within a tune", data: audioVM.audio.recording.recordedAmplitude)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 24))
        .foregroundColor(.neutral.onBackground)
    }
}

struct RecordingAnalyticsDrawer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAnalyticsDrawerView(isShowing: .constant(true)
        )
        .environmentObject(RecordingAnalyticsDrawerViewModel())
        .environmentObject(AudioViewModel())
    }
}
