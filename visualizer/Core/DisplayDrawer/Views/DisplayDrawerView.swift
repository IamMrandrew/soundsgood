//
//  DIsplayDrawerViewModel.swift
//  visualizer
//
//  Created by John Yeung on 29/6/2022.
//

import SwiftUI

struct DisplayDrawerView: View {
    @EnvironmentObject var vm: DisplayDrawerViewModel
    @Binding var isShowing: Bool
    @Binding var isShowingModal: Bool
    
    func choose(display: DisplayDrawer.DisplayTypes) -> Void {
        if (vm.displayDrawer.selected != display){
            vm.displayDrawer.selected = display
            
        } else {
            vm.displayDrawer.selected = DisplayDrawer.DisplayTypes.none
        }
    }
    
    var body: some View {
        DrawerView(isShowing: $isShowing, isShowingModal: $isShowingModal) {
            VStack(alignment: .leading) {
                Text(//selectedFeature.rawValue)
                    "Display")
                    .font(.heading.small)
                    // Weird alignment behaviour, Workaround only
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 16)
                
                VStack(alignment: .leading){
                    HStack(){
                        VStack(){
                            DisplayDrawerItemButton(action: choose, type: DisplayDrawer.DisplayTypes.musicalNotes, selected: vm.isSelected(DisplayDrawer.DisplayTypes.musicalNotes))
                                .previewLayout(.fixed(width: 64, height: 64))
                        }
                    }
                }
                .padding()
                
                Spacer()
                    .frame(height: 32)
                
                
            }
            .padding(EdgeInsets(top: 40, leading: 32, bottom: 40, trailing: 32))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            // For dragging gesture
            .background(Color.neutral.background.opacity(0.00001))
        }
    }
}

struct MusicalNotesIndicatorDrawer_Previews: PreviewProvider {
    static var previews: some View {
        DisplayDrawerView(isShowing: .constant(true),
                                isShowingModal: .constant(true)
        )
        .environmentObject(DisplayDrawerViewModel())
    }
}
