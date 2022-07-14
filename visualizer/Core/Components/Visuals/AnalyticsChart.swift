//
//  AnalyticsChart.swift
//  visualizer
//
//  Created by Yeung on 14/7/2022.
//

import SwiftUI

struct AnalyticsChart: View {
    let title: String
    let descriptiveText: String
    
    var body: some View {
        VStack {
            HStack(){
                Text(title)
                .font(.system(size: 18))
                .bold()
                .padding(.leading)
                Spacer()
            }
            // Amplitudes()// to be replaced by the line chart later
            HStack(){
                Text(descriptiveText).padding([.leading, .bottom])
                Spacer()
            }
        }
    }
}

struct AnalyticsChart_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsChart(title: "Dynamic", descriptiveText: "Attack, Sustain, Release, Decay")
            .environmentObject(AudioViewModel())
    }
}
