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
                    Button("Notes", action: {
                        recordingAnalyticsDrawerVM.recordingAnalyticsDrawer.selected = RecordingAnalyticsDrawer.AnalyticsTypes.notes
                    })
                    Button("Melody", action: {
                        recordingAnalyticsDrawerVM.recordingAnalyticsDrawer.selected = RecordingAnalyticsDrawer.AnalyticsTypes.melody
                    })
                    Spacer()
                }
                
                Amplitudes()
                if (recordingAnalyticsDrawerVM.isSelected(RecordingAnalyticsDrawer.AnalyticsTypes.notes)){
                    AnalyticsChart(title: "Dynamic", descriptiveText: "How consistent your dyanmic is")
                    AnalyticsChart(title: "Accuracy", descriptiveText: "How many percent you are in tune")
                } else if (recordingAnalyticsDrawerVM.isSelected(RecordingAnalyticsDrawer.AnalyticsTypes.melody)){
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
