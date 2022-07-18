//
//  RecordingAnalyticsDrawerView.swift
//  visualizer
//
//  Created by Yeung on 13/7/2022.
//

import Foundation
import SwiftUI

struct RecordingAnalyticsDrawerView: View {
    @EnvironmentObject var recordingAnalyticsDrawerVM: RecordingAnalyticsDrawerViewModel
    @EnvironmentObject var audioVM: AudioViewModel
    @Binding var isShowing: Bool
    @Binding var isShowingModal: Bool
    
    @State private var analyticsMode: RecordingAnalyticsDrawer.AnalyticsTypes = .notes
    
    let onClose: () -> Void
    
    var body: some View {
        DrawerView(isShowing: $isShowing, isShowingModal: $isShowingModal) {
            VStack(alignment: .leading) {
                ZStack(){
                    HStack(){
                        Spacer()
                        Text("Analytics")
                            .font(.system(size: 22))
                            .bold()
                        Spacer()
                    }
                    HStack(){
                        Spacer()
                        CloseButton(action: onClose)
                            .padding([.top, .bottom, .trailing])
                    }
                }
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
                
                Amplitudes()
                switch analyticsMode {
                case .notes:
                    AnalyticsChart(title: "Dynamic", descriptiveText: "How consistent your dyanmic is")
                    AnalyticsChart(title: "Accuracy", descriptiveText: "How many percent you are in tune")
                case .melody:
                    AnalyticsChart(title: "Dynamic", descriptiveText: "Attack, Sustain, Release, Decay")
                    AnalyticsChart(title: "Accuracy", descriptiveText: "How your pitch change within a tune")
                }
                
                
            }
        }
        
    }
}

struct RecordingAnalyticsDrawer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAnalyticsDrawerView(isShowing: .constant(true),
                                isShowingModal: .constant(true),
                                     onClose: {}
        )
        .environmentObject(RecordingAnalyticsDrawerViewModel())
        .environmentObject(AudioViewModel())
    }
}
