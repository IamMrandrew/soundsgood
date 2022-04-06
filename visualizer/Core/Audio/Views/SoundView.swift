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
    
    var body: some View {
        ZStack {
            Color.neutral.background
                .ignoresSafeArea(.all)
            ZStack(alignment: .top) {
                
                VStack {
                    
                    Spacer()
                    
                    Amplitudes()
                    
                    Spacer()
                    
                    CaptureTimeButton(action: vm.switchCaptureTime,captureTime: vm.audio.captureTime)
                    
                }
                .padding(.top, 72)
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottom)
                .sheet(isPresented: $showSheet, content: {
                    SettingView(showTutorial: $showTutorial)
                        .environmentObject(vm.settingVM)
                })
                
                VStack(alignment: .trailing) {
                    Spacer()
                    VPitchIndicator(pitchLetter: $vm.audio.pitchNotation, position: vm.getPitchIndicatorPosition())
                    Spacer()
                }
                .padding(.top, 42)
                .padding(.trailing, 12)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .trailing)
                
                HStack(alignment: .top) {
                    MoreButton(action: {showSheet.toggle()})
                        .padding(15)
                    
                    Spacer()
                    
                    LiveDropdown(isPitchAccurate: $vm.audio.isPitchAccurate,
                                 isWatchLive: $watchConnectVM.isLive,
                                 start: vm.start,
                                 stop: vm.stop,
                                 options: [3,5,10],
                                 sendIsLive: watchConnectVM.sendIsLive
                    )
                        .padding(15)
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
        }
        
    }
}

struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        SoundView()
            .environmentObject(AudioViewModel())
            .environmentObject(WatchConnectivityViewModel())
    }
}
