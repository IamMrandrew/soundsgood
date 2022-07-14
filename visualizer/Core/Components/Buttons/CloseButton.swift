//
//  CloseButton.swift
//  visualizer
//
//  Created by Yeung on 14/7/2022.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: "xmark")
                .frame(width: 40, height: 40)
                .foregroundColor(.neutral.onSurface)
                .background(Color.neutral.surface)
                .clipShape(Circle())
                .font(.system(size: 18))
        }
        .accessibilityIdentifier("More Button")
    }
}

struct CloseButton_Previews: PreviewProvider {
    static func test() -> Void {
        print("Close Button Clicked")
    }
    
    static var previews: some View {
        CloseButton(action: self.test)
    }
}
