//
//  DrawerView.swift
//  visualizer
//
//  Created by Mark Cheng on 15/2/2022.
//

import SwiftUI
import UIKit

struct DrawerView<Content: View>: View {
    @Binding var isShowing: Bool
    @Binding var isShowingModal: Bool
    
    @ViewBuilder var content: Content
    @State private var curHeight: CGFloat = 400
    @State private var prevDragTranslation = CGSize.zero
    
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    var body: some View {
        ZStack(alignment:.bottom) {
            if (isShowing) {
                Color.neutral.overlay
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        isShowing = false
                        isShowingModal = false
                    }
                    .animation(.default)
                
                HStack(alignment: .top) {
                    content
                        .gesture(dragGesture)
                }
                .transition(.move(edge: .bottom))
                .frame(height: curHeight, alignment: .top)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                        Rectangle()
                            .frame(height: curHeight/2)
                    }
                        .foregroundColor(.neutral.background)
                )
                
            }
        }        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeOut(duration: 0.25))
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = .zero
                
                if curHeight > maxHeight {
                    curHeight = maxHeight
                }
                else if curHeight < minHeight {
                    curHeight = minHeight
                }
                
                let velocity = CGSize(
                    width: val.predictedEndLocation.x - val.location.x,
                    height: val.predictedEndLocation.y - val.location.y
                )
                
                if velocity.height > 300.0 {
                    isShowing = false
                    isShowingModal = false
                }
            }
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(isShowing: .constant(true), isShowingModal: .constant(true)){
            Text("test")
            
        }
    }
}
