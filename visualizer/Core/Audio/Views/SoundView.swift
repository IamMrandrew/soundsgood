//
//  SoundView.swift
//  visualizer
//	
//  Created by Mark Cheng on 7/11/2021.
//

import SwiftUI

struct SoundView: View {
    @EnvironmentObject var vm: AudioViewModel
    @EnvironmentObject var watchConnectVM: WatchConnectivityViewModel


    @AppStorage(InteractiveTutorial.Page.pitch.rawValue) var firstLaunch: Bool?

    @State private var showSheet: Bool = false
    @State private var showTutorial: Bool = false
    @State private var showDisplayDrawer: Bool = false
    @State private var showRecordingAnalyticsDrawer: Bool = false
    
    // A global state to know if any custom modal (DrawerView) is showing
    // so that a cover for tab will appear/ disappear
    @Binding var isShowingModal: Bool
    	
    var body: some View {
        ZStack {
            Color.neutral.background
                .ignoresSafeArea(.all)
            ZStack(alignment: .top) {
                
                VStack {
                    
                    Spacer()
                    
                    Amplitudes()
                    
                    Spacer()
                    
                    CaptureTimeButton(
                        action: {
                            if (vm.audio.recording.isRecording){
                                // user stop recording
                                // display the analytics sheet
                                showRecordingAnalyticsDrawer.toggle()
                            }
                            vm.audio.recording.toggleRecording()
                            
                        },
                        captureTime: vm.audio.captureTime,
                        isRecording: vm.audio.recording.isRecording)
                    
                    Spacer()
                        .frame(height: 60)
                    
//                    Text(String(vm.audio.recording.recordedAmplitude.count))
//                    Text(String(vm.audio.recording.isRecording))
//                    Text(String(vm.audio.recording.timeCap))
                    
                }
                .padding(.top, 72)
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottom)
                .sheet(isPresented: $showSheet, content: {
                    SettingView(showTutorial: $showTutorial)
                        .environmentObject(vm.settingVM)
                })
                .sheet(isPresented: $showRecordingAnalyticsDrawer, content: {
                    RecordingAnalyticsDrawerView(isShowing: $showRecordingAnalyticsDrawer)
                        .environmentObject(vm.RecordingAnalyticsVM)
                })
                
                
                VStack(alignment: .trailing) {
                    
                    if(vm.DisplayDrawerVM.isSelected( DisplayDrawer.DisplayTypes.musicalNotes)){
                        Spacer()
                        VPitchIndicator(pitchLetter: $vm.audio.pitchNotation, position: vm.getPitchIndicatorPosition())
                        Spacer()
                    }
                }
                .padding(.top, 42)
                .padding(.trailing, 12)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .trailing)
                
                HStack(alignment: .top) {
                    MoreButton(action: {showSheet.toggle()})
                        .padding(15)
                    
                    Spacer()
                    
                    HStack(alignment: .top){
                        DisplayDrawerButton(action:{
                            showDisplayDrawer.toggle()
                            isShowingModal.toggle()
                        })
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                        LiveDropdown(isWatchLive: $watchConnectVM.isLive,
                                     start: vm.start,
                                     stop: vm.stop,
                                     options: [1,3,5],
                                     sendIsLive: watchConnectVM.sendIsLive
                        ).padding(15)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            ZStack {
                if (showTutorial) {
                    InteractiveTutorialView(showTutorial: $showTutorial,
                                            page: InteractiveTutorial.Page.pitch)
                        .animation(.default)
                }
            }
            .transition(.opacity.animation(.easeIn(duration: 0.3)))
            .animation(.default)
            .onAppear {
                guard let _ = firstLaunch else {
                    showTutorial.toggle()
                    firstLaunch = false
                    return
                }
            
            }
            
            // show the DisplayDrawerView on DisplayDrawerButton (the one with layers icon) click
             ZStack {
                 DisplayDrawerView(isShowing: $showDisplayDrawer,
                                  isShowingModal: $isShowingModal
                 ).environmentObject(vm.DisplayDrawerVM)

             }
            
        }
        
    }
}

struct SoundView_Previews: PreviewProvider {
    @State static var isShowingModal: Bool = false
    static var previews: some View {
        Group {
            SoundView(isShowingModal: $isShowingModal)
                .previewDevice("iPhone 12")
                .environmentObject(AudioViewModel())
                .environmentObject(WatchConnectivityViewModel())
        }
    }
}
