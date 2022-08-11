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
    @EnvironmentObject var vm: AudioViewModel
    @Binding var isShowing: Bool
    
    @State private var analyticsMode: RecordingAnalyticsDrawer.AnalyticsTypes = .melody
    @State private var noteSelectedToAnalyze: Int = 0
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Presentation Sheet Header
                Group {
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
                }
                
                Spacer()
                    .frame(height: 32)
                
                // Segmented Control
                HStack(){
                    Spacer()
                    Picker("Analysis Mode", selection: $analyticsMode) {
                        Text(RecordingAnalyticsDrawer.AnalyticsTypes.melody.label)
                            .tag(RecordingAnalyticsDrawer.AnalyticsTypes.melody)
                        Text(RecordingAnalyticsDrawer.AnalyticsTypes.notes.label)
                            .tag(RecordingAnalyticsDrawer.AnalyticsTypes.notes)
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 24))
            .foregroundColor(.neutral.onBackground)
            
            Spacer()
                .frame(height: 32)
            
            VStack {
                RecordingAmplitudes(amplitudes: vm.audio.audioRecording.recording.map { $0.amplitude },
                                    noteSelectedToAnalyze: $noteSelectedToAnalyze,
                                    splittedNoteIndices: vm.audio.audioRecording.splittedNoteIndices)
            }
            .frame(maxWidth: .infinity, maxHeight: 150)
            .background(Color("surfaceVariant"))
            
            Spacer()
                .frame(height: 32)
            
            VStack(alignment: .leading) {
                switch analyticsMode {
                case .melody:
                    VStack {
                        AnalyticsChart(title: "Dynamic",
                                       descriptiveText: "How consistent your dynamic is",
                                       data: vm.audio.audioRecording.recording.map { $0.amplitude },
                                       legend: "Amplitude"
                        )
                        
                        Spacer()
                            .frame(height: 32)
                        
                        AnalyticsChart(title: "Accuracy",
                                       descriptiveText: "What percent are you in tune",
                                       data: vm.audio.audioRecording.recording.map { $0.pitchDetune },
                                       legend: "Cent"
                        )
                    }
                case .notes:
                    VStack {
                        AnalyticsChart(title: "Dynamic",
                                       descriptiveText: "Attack, Sustain, Release, Decay",
                                       data: vm.audio.audioRecording.splittedRecording.count > 0 ? vm.audio.audioRecording.splittedRecording[noteSelectedToAnalyze].map { $0.amplitude } : [],
                                       legend: "Amplitude"
                        )
                        
                        Spacer()
                            .frame(height: 32)
                        
                        AnalyticsChart(title: "Accuracy",
                                       descriptiveText: "How your pitch change within a note",
                                       data:  vm.audio.audioRecording.splittedRecording.count > 0 ? vm.audio.audioRecording.splittedRecording[noteSelectedToAnalyze].map { $0.pitchDetune } : [],
                                       legend: "Cent")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
            .foregroundColor(.neutral.onBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RecordingAnalyticsDrawer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAnalyticsDrawerView(isShowing: .constant(true)
        )
        .environmentObject(AudioViewModel())
    }
}
