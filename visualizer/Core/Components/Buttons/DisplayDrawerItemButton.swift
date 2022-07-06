//
//  MusicalNotesButton.swift
//  visualizer
//
//  Created by John Yeung on 30/6/2022.
//

import SwiftUI

struct DisplayDrawerItemButton: View {
    // future add alass MusicalNotesDrawer.MusicalNotesTypes
    let action: (DisplayDrawer.DisplayTypes)->Void
    let type: DisplayDrawer.DisplayTypes
    var selected: Bool
    
    var body: some View {
        VStack {
            Button {
                self.action(type)
            } label: {
                // to be replaced with a image file in the future
                Image(uiImage: UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(.neutral.onSurface)
            }
            .frame(width: 64, height: 64)
            .background(Color.neutral.surface)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.neutral.surface, lineWidth: 3)
            )
            .if (selected) {
                $0.overlay (
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.foundation.primary, lineWidth: 3)
                )
            }
            Text(type.label)
                .font(.label.small)
                .lineLimit(nil)
                .fixedSize(horizontal: true, vertical: false)
                
        }
    }
}

struct DisplayDrawerItemButton_Previews: PreviewProvider {
    static func test(type: DisplayDrawer.DisplayTypes) -> Void {
        print("Musical Notes Button Clicked")
    }
    
    static var previews: some View {
        DisplayDrawerItemButton(action: self.test, type: DisplayDrawer.DisplayTypes.musicalNotes, selected: true)
            .previewLayout(.fixed(width: 80, height: 80))
        DisplayDrawerItemButton(action: self.test, type: DisplayDrawer.DisplayTypes.dynamic, selected: false)
            .previewLayout(.fixed(width: 80, height: 80))
        DisplayDrawerItemButton(action: self.test, type: DisplayDrawer.DisplayTypes.xxx, selected: false)
            .previewLayout(.fixed(width: 80, height: 80))
    }
}

