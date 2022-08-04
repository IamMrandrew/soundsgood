//
//  RecordingAmplitudes.swift
//  visualizer
//
//  Created by Andrew Li on 2/8/2022.
//

import SwiftUI

struct RecordingAmplitudes: View {
    var amplitudes: [[Double]]
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        if (amplitudes.count > 0) {
                            ForEach(0...amplitudes.count-1, id: \.self) { i in
                                ForEach(0...amplitudes[i].count-1, id: \.self) { j in
                                    AmplitudesBar(amplitudes[i][j])
                                }
                            }
                        }
                    }
                }
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
            .frame(width: CGFloat(4), height: CGFloat(300 * amplitude))
            .cornerRadius(4)
            .animation(.easeOut(duration: 0.15))
    }
    
}

struct RecordingAmplitudes_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAmplitudes(amplitudes:
                                [[0.02304413728415966], [0.030622100457549095, 0.04528215527534485, 0.0653424859046936, 0.1539716273546219, 0.16726064682006836, 0.2088763266801834, 0.23036545515060425, 0.2151966691017151, 0.18601100146770477, 0.08696883916854858, 0.06131352111697197, 0.04755564033985138, 0.024082768708467484], [0.0273892842233181, 0.0713433176279068, 0.22868084907531738, 0.1453639417886734, 0.1154831200838089, 0.1603870987892151, 0.1784013956785202, 0.17847129702568054, 0.1636769324541092, 0.16243833303451538, 0.1752234399318695, 0.19591112434864044, 0.1827610731124878, 0.19491969048976898, 0.2007552832365036, 0.1952378898859024, 0.19244341552257538, 0.17963826656341553, 0.17057906091213226, 0.18306568264961243, 0.16698907315731049, 0.17206810414791107, 0.1779678463935852, 0.1748470813035965, 0.17678454518318176, 0.17406006157398224, 0.17420782148838043, 0.18460242450237274, 0.17133241891860962, 0.17417584359645844, 0.18671062588691711, 0.1861659586429596, 0.195707306265831, 0.1638619303703308, 0.10670460760593414, 0.03131432086229324]]
        )
        
    }
}
