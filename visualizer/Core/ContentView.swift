import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioViewModel: AudioViewModel
    @EnvironmentObject var watchConnectivityViewModel: WatchConnectivityViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var systemColorScheme
    
    @State private var selection: Tab = .pitch
    @State private var selectionSidebar: Tab? = .pitch
    
    @State private var isShowingModal: Bool = false    
    
    var isCompact: Bool { horizontalSizeClass == .compact}
    
    enum Tab: CaseIterable, Identifiable {
        case sound
        case pitch
        case timbre
        
        var id: String { title }
        
        var title: String {
            switch self {
            case .sound:
                return "Sound"
            case .pitch:
                return "Pitch"
            case .timbre:
                return "Timbre"
            }
        }
        
        var systemImage: String {
            switch self {
            case .sound:
                return "waveform.and.magnifyingglass"
            case .pitch:
                return "music.note.list"
            case .timbre:
                return "waveform.path.ecg"
            }
        }
    }
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color.neutral.background)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
    }
    
    //TODO: tab view animation
    var body: some View {
        if isCompact {
            ZStack {
                TabView(selection: $selection) {
                    ForEach(Tab.allCases) { item in
                    views(item)
                            .tabItem {
                                Label(item.title, systemImage: item.systemImage)
                            }
                            .tag(item)
                            .preferredColorScheme(audioViewModel.settingVM.getScheme())
                            
                    }
                }
                .accentColor(.foundation.primary)
                
                
                if (isShowingModal) {
                    HStack {
                        Spacer()
                        
                        VStack {}
                        .frame(maxWidth: .infinity,maxHeight: 80)
                        .background(Color.neutral.background)
                        
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(.all)
                }
                    
                    
               
            }.onAppear{
                audioViewModel.settingVM.systemColorScheme = systemColorScheme
            }
        } else {
            NavigationView {
                List(Tab.allCases, selection: $selectionSidebar) { item in
                    NavigationLink(destination: views(item)
                                    .navigationBarTitle("", displayMode: .inline)
                                    .preferredColorScheme(audioViewModel.settingVM.getScheme())
                                   ,
                                   tag: item,
                                   selection: $selectionSidebar
                    ) {
                        Label(item.title, systemImage: item.systemImage)
                            .tag(item)
                    }                    
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitle(Text("Screens"))
            }
            .accentColor(.foundation.primary)
            .onAppear{
                audioViewModel.settingVM.systemColorScheme = systemColorScheme
            }
        }
    }
    
    @ViewBuilder
    func views(_ destination: Tab) -> some View {
        switch destination {
        case .sound:
            SoundView(isShowingModal: $isShowingModal)
                .environmentObject(audioViewModel)
                .environmentObject(watchConnectivityViewModel)
        case .pitch:
            PitchView()
                .environmentObject(audioViewModel)
                .environmentObject(watchConnectivityViewModel)
        case .timbre:
            TimbreView(isShowingModal: $isShowingModal)
                .environmentObject(audioViewModel)
                .environmentObject(watchConnectivityViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioViewModel())
            .environmentObject(WatchConnectivityViewModel())
    }
}
