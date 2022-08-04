//
//  AnalyticsChart.swift
//  visualizer
//
//  Created by Yeung on 14/7/2022.
//
// chart reference https://github.com/willdale/SwiftUICharts/tree/release/1

import SwiftUI
import SwiftUICharts

struct AnalyticsChart: View {
    let title: String
    let descriptiveText: String
    let data: [Double]
    //let chartTitle: String
    var chartData: LineChartData {
        get {
            return generateChartData(data: data)
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.label.medium)
            
            Spacer()
                .frame(height: 8)
            
            LineChart(chartData: chartData)
                .pointMarkers(chartData: chartData)
                .xAxisGrid(chartData: chartData)
            
            Spacer()
                .frame(height: 8)
            
            Text(descriptiveText)
                .foregroundColor(.neutral.onBackgroundVariant)
                .font(.label.xsmall)
        }
    }
    
    func generateChartData(data: Array<Double>)->LineChartData{
        var chartDataSet : [LineChartDataPoint] = []
        
        for dataPoint in data{
            chartDataSet.append(LineChartDataPoint(value: dataPoint))
        }
        let chartData = LineDataSet(dataPoints: chartDataSet,
                                    pointStyle: PointStyle(pointSize:0.0, lineWidth: 0.0),
                                    style: LineStyle(
                                        lineColour: ColourStyle(colour: .accent.highlight),
                                        lineType: .line))
           
        let metadata   : ChartMetadata  = ChartMetadata(title       : "",
                                                        subtitle    : "")
        

        let gridStyle   : GridStyle     = GridStyle(lineColour  : .neutral.axis,
                                                    lineWidth   : 1,
                                                    dash: [CGFloat]())
        
        let chartStyle  : LineChartStyle    = LineChartStyle(infoBoxPlacement: .header,
                                                     yAxisGridStyle: GridStyle(lineColour: Color.primary.opacity(0.5)))
        
        return LineChartData(dataSets   : chartData,
                         metadata       : metadata,
                         chartStyle     : chartStyle
        )
    

    }
}

struct AnalyticsChart_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsChart(title: "Dynamic", descriptiveText: "Attack, Sustain, Release, Decay", data: [2, 1, 5, 3, 2])
            .environmentObject(AudioViewModel())
    }
}
