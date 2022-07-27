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
        VStack {
            HStack(){
                Text(title)
                .font(.system(size: 18))
                .bold()
                .padding(.leading)
                Spacer()
            }
            // Amplitudes()// to be replaced by the line chart later
            LineChart(chartData: chartData)
                .pointMarkers(chartData: chartData)
                .xAxisGrid(chartData: chartData)
            
            HStack(){
                Text(descriptiveText).padding([.leading, .bottom])
                Spacer()
            }
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
                                        lineColour: ColourStyle(colour: .red),
                                        lineType: .line))
           
        let metadata   : ChartMetadata  = ChartMetadata(title       : "",
                                                        subtitle    : "")
        

        let gridStyle   : GridStyle     = GridStyle(lineColour  : Color(.lightGray).opacity(0.25),
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
