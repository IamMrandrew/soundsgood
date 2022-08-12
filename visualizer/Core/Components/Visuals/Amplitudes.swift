//
//  Amplitudes.swift
//  visualizer
//
//  Created by Mark Cheng on 16/4/2022.
//
// REF: https://github.com/DuncanMC/LastNItemsBufferGraph

import SwiftUI
import UIKit

struct Amplitudes: View {
    
    @State private var timer: Timer? = nil
    @EnvironmentObject var vm: AudioViewModel
    @State private var value: (Double, Int) = (0.0, 0)
    @State private var buffer = AmplitudeBuffer<CGFloat>.init(count: Int(UIScreen.screenWidth / 8 * 2))
    // force update to make animation smoother
    @State private var counter = 0
    
    private let anchorId = 999999
    
    var body: some View {
        ScrollView(.horizontal){
            ScrollViewReader{proxy in
                ZStack{
                    GraphView(value: $value, points: $buffer, captureTime: vm.audio.captureTime)
                        .onChange(of: vm.isStarted){ _ in
                            if(!vm.isStarted){
                                self.timer?.invalidate()
                            }else{
                                self.timer = Timer.scheduledTimer(
                                    withTimeInterval: 0.05,
                                    repeats: true)
                                { (timer) in
                                    value = (vm.audio.lastAmplitude * 30, counter)
                                    
                                    // Store the amplitude along with the displayed one
                                    // Store the pitch data along with the displayed one
                                    vm.addRecordingData()
                                    
                                    if(counter == 10) {
                                        counter = 0
                                    } else {
                                        counter += 1
                                    }
                                }
                            }
                        }
                        .onChange(of: vm.audio.captureTime){ _ in
                            proxy.scrollTo(anchorId)
                        }
                        .onAppear{
                            if(vm.isStarted){
                                buffer.forceToValue(0.0)
                                self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
                                    value = (vm.audio.lastAmplitude * 30, counter)
                                    
                                    // Store the amplitude along with the displayed one
                                    // Store the pitch data along with the displayed one
                                    vm.addRecordingData()
                                    
                                    if(counter == 10) {
                                        counter = 0
                                    } else {
                                        counter += 1
                                    }
                                }
                            }
                        }
                    // anchor
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 3, height: 15)
                        .position(x: UIScreen.screenWidth * (log2(CGFloat(vm.audio.captureTime))+1), y: UIScreen.screenHeight / 2)
                        .id(anchorId)
                        .opacity(0)
                }
                .frame(width: UIScreen.screenWidth * CGFloat(vm.audio.captureTime), alignment: .trailing)
                .onAppear{
                    withAnimation{
                        proxy.scrollTo(anchorId, anchor: .trailing)
                    }
                }
            }
        }
    }
}

struct Amplitudes_Previews: PreviewProvider {
    static var previews: some View {
        Amplitudes()
            .environmentObject(AudioViewModel())
    }
}

// use UIKit to draw bar graph
struct GraphView: UIViewRepresentable {
    @Binding var value: (Double, Int)
    @Binding var points: AmplitudeBuffer<CGFloat>
    var captureTime: Int
    
    func makeUIView(context: Context) -> BarGraphView {
        let view = BarGraphView()
        view.points = points
        return view
    }
    
    func updateUIView(_ uiView: BarGraphView, context: Context) {
        let (amp, _) = value
        uiView.animateNewValue(amp)
        uiView.captureTime = captureTime
    }
}

class BarGraphView: UIView {

    public var maxValue: CGFloat = 100
    public var minValue: CGFloat = -100
    
    public var captureTime: Int = 2
    private var curCaptureTime: Int = 2

    public var points: AmplitudeBuffer<CGFloat>? {
        didSet {
            guard let layer = self.layer as? CAShapeLayer else { return }
            if oldValue == nil {
                layer.path = buildPath().path
            }
        }
    }

    static override var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInitSetup()
    }

    func doInitSetup() {
        guard let layer = self.layer as? CAShapeLayer else { return }
        layer.strokeColor = UIColor(Color.foundation.secondary).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3
        layer.lineCap = .round
    }

    public func animateNewValue(_ value: CGFloat, duration: Double = 0.05) {
        guard let layer = self.layer as? CAShapeLayer else { return }
        let oldPathInfo = buildPath(plusValue: value)

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration

        animation.fromValue = oldPathInfo.path

        var transform = CGAffineTransform(translationX: -oldPathInfo.stepWidth, y: 0)
        animation.toValue = oldPathInfo.path.copy(using: &transform)

        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        layer.add(animation, forKey: nil)

        points?.write(value)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            layer.path = self.buildPath().path
        }
    }

    private func buildPath(plusValue: CGFloat? = nil) -> (path: CGPath, stepWidth: CGFloat) {
        if(curCaptureTime != captureTime){
            self.points?.resize(Int(UIScreen.screenWidth) / 8 * captureTime)
            curCaptureTime = captureTime
        }
        guard let points = points else {
            (layer as? CAShapeLayer)?.path = nil
            return (CGMutablePath(), 0)
        }
        let graphBounds = bounds.insetBy(dx: 0, dy: 6)
//        let stepWidth = graphBounds.width / (CGFloat(points.count) - 1)
        let stepWidth = (UIScreen.screenWidth * CGFloat(captureTime)) / (CGFloat(points.count) - 1)
        
        let range = minValue - maxValue
        let stepHeight = graphBounds.height  / range

        func pointsForIndex(_ index: Int, value: CGFloat) -> (top: CGPoint, bottom: CGPoint) {
            let top = graphBounds.height / 2 + abs(value) * stepHeight + graphBounds.origin.y
            let bottom = graphBounds.height / 2 - abs(value) * stepHeight + graphBounds.origin.y
            let x = CGFloat(index) * stepWidth + graphBounds.origin.x
            return (CGPoint(x: x, y: top), CGPoint(x: x, y: bottom))
        }
        let path = CGMutablePath()
        for (index, value) in points.values().enumerated() {
            let points = pointsForIndex(index, value: value)
            path.move(to: points.top)
            path.addLine(to: points.bottom)
        }
        if let extraValue = plusValue {
            let points = pointsForIndex(points.count, value: extraValue)
            path.move(to: points.top)
            path.addLine(to: points.bottom)
        }
        return (path, stepWidth)
    }
}

