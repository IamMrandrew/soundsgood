//
//  DisplayButton.swift
//  visualizer
//
//  Created by John Yeung on 29/6/2022.
//

// import Foundation
import SwiftUI

struct DisplayDrawerButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: "square.stack.3d.down.right.fill")
                .frame(width: 48, height: 48)
                .foregroundColor(.neutral.onSurface)
                .background(Color.neutral.surface)
                .clipShape(Circle())
                .font(.system(size: 22))
        }
    }
}

struct DisplayDrawerBtn_Previews: PreviewProvider {
    static func test() -> Void {
        print("Drawer Button Clicked")
    }
    static var previews: some View {
        DisplayDrawerButton(action: self.test)
            .previewLayout(.fixed(width: 45, height: 38))
    }
}
