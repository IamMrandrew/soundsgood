//
//  RecordingAmplitudes.swift
//  visualizer
//
//  Created by Andrew Li on 2/8/2022.
//
// ref: https://stackoverflow.com/a/62588295/10471260 for the logic of
// getting current position of scrolling

import SwiftUI

struct RecordingAmplitudes: View {
    var amplitudes: [Double]
    @Binding var noteSelectedToAnalyze: Int
    var splittedNoteIndices: [Int]
    
    @State private var currentPos: Int = 0  // Estimated index of recording of the current scrolled note
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        if (amplitudes.count > 0) {
                            ForEach(0...amplitudes.count-1, id: \.self) { i in
                                AmplitudesBar(amplitudes[i])
                            }
                        }
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                                               value: -$0.frame(in: .named("scroll")).origin.x)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        // Try to map the scroll offset to the each bar width
                        currentPos = Int($0) / 9
                        let index = splittedNoteIndices.firstIndex(where: { $0 > currentPos}) ?? splittedNoteIndices.count
                        noteSelectedToAnalyze = max(0, index - 1)
                        
                        print("DEBUG: currentPos >> \(currentPos)")
                        print("DEBUG: noteSelectedToAnalyze >> \(noteSelectedToAnalyze)")
                    }
                }
                .coordinateSpace(name: "scroll")
            }
            .onAppear {
                withAnimation {
                    //                        proxy.scrollTo(anchorId, anchor: .trailing)
                }
            }
        }
        .frame(height: 140)
    }
}

private extension RecordingAmplitudes {
    
    // Small component to render amplitude bar
    func AmplitudesBar(_ amplitude: Double) -> some View {
        Rectangle()
            .fill(Color.foundation.secondary)
            .frame(width: CGFloat(4), height: CGFloat(250 * amplitude))
            .cornerRadius(4)
            .animation(.easeOut(duration: 0.15))
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct RecordingAmplitudes_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAmplitudes(amplitudes:
                                [0.01412819791585207, 0.014033089391887188, 0.014033089391887188, 0.015931077301502228, 0.015931077301502228, 0.023936737328767776, 0.023936737328767776, 0.017341701313853264, 0.017341701313853264, 0.014586826786398888, 0.014586826786398888, 0.013239243999123573, 0.015910087153315544, 0.015910087153315544, 0.1321689486503601, 0.1321689486503601, 0.3248618245124817, 0.3248618245124817, 0.43137165904045105, 0.43137165904045105, 0.44218429923057556, 0.44218429923057556, 0.23177525401115417, 0.23177525401115417, 0.07975081354379654, 0.021230246871709824, 0.021230246871709824, 0.014851400628685951, 0.014851400628685951, 0.015354848466813564, 0.015354848466813564, 0.013624142855405807, 0.013624142855405807, 0.014209222979843616, 0.014209222979843616, 0.02242797240614891, 0.02242797240614891, 0.16083289682865143, 0.2585010826587677, 0.2585010826587677, 0.19936968386173248, 0.13652461767196655, 0.13652461767196655, 0.053008973598480225, 0.053008973598480225, 0.016013149172067642, 0.016013149172067642, 0.014622432179749012, 0.014622432179749012, 0.01320960558950901, 0.01427688729017973, 0.01427688729017973, 0.09833644330501556, 0.09833644330501556, 0.21849247813224792, 0.21849247813224792, 0.20817828178405762, 0.20817828178405762, 0.19525349140167236, 0.19525349140167236, 0.20504219830036163, 0.20504219830036163, 0.19291271269321442, 0.1614731401205063, 0.1614731401205063, 0.13707026839256287, 0.13707026839256287, 0.09215047210454941, 0.09215047210454941, 0.10058171302080154, 0.10058171302080154, 0.19595207273960114, 0.19595207273960114, 0.18372340500354767, 0.18372340500354767, 0.1854892373085022, 0.19747363030910492, 0.19747363030910492, 0.17963165044784546, 0.17963165044784546, 0.10905958712100983, 0.10905958712100983, 0.016229908913373947, 0.016229908913373947, 0.014313231222331524, 0.014313231222331524, 0.015526365488767624, 0.015526365488767624, 0.013643501326441765, 0.015055728144943714, 0.015055728144943714, 0.016424741595983505, 0.016424741595983505, 0.015565527603030205],
                            noteSelectedToAnalyze: .constant(0),
                            splittedNoteIndices: [14, 37, 51]
        )
        
    }
}
