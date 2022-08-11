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
    let legend: String
    
    // Workaround to initalize ChartData for SwiftUICharts
    @State var chartData: LineChartData = LineChartData(dataSets: LineDataSet(
        dataPoints: [LineChartDataPoint(value: 0)]
    ))
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.neutral.onBackground)
                .font(.label.medium)
            
            Spacer()
                .frame(height: 8)
            
            LineChart(chartData: chartData)
                .pointMarkers(chartData: chartData)
                .xAxisGrid(chartData: chartData)
                .touchOverlay(chartData: chartData, specifier: "%.03f")
                .floatingInfoBox(chartData: chartData)
                .id(chartData.id)
                .frame(height: 150)
            
            Spacer()
                .frame(height: 8)
            
            Text(descriptiveText)
                .foregroundColor(.neutral.onBackgroundVariant)
                .font(.label.xsmall)
        }
        .onAppear() {
            chartData = generateChartData(data: data, legend: legend)
        }
        .onChange(of: data) { value in
            chartData = generateChartData(data: value, legend: legend)
        }
    }
}

private extension AnalyticsChart {
    
    func generateChartData(data: Array<Double>, legend: String) -> LineChartData {
        var chartDataSet : [LineChartDataPoint] = []
        
        for dataPoint in data {
            if (legend == "Frequency") {
                // Put Pitch Letter on description (Show inside Info Box
                let pitchLetter = pitchFromFrequency(Float(dataPoint), Setting.NoteRepresentation.flat)
                chartDataSet.append(LineChartDataPoint(value: dataPoint, description: pitchLetter))
            } else {
                chartDataSet.append(LineChartDataPoint(value: dataPoint))
            }
        }
        
        let chartData = LineDataSet(dataPoints: chartDataSet,
//      Remark: Disable point as we haven't manage to show point only on peak
//                                    pointStyle: PointStyle(pointSize: 10.0,
//                                                           borderColour: .accent.highlight,
//                                                           fillColour: .white,
//                                                           lineWidth: 3.0,
//                                                           pointType: .filledOutLine,
//                                                           pointShape: .circle
//                                                          ),
                                    legendTitle: legend,
                                    pointStyle: PointStyle(pointSize: 0.0, lineWidth: 0.0),
                                    style: LineStyle(
                                        lineColour: ColourStyle(colour: .accent.highlight),
                                        lineType: .line)
                                    
        )
        
        let metadata = ChartMetadata(title: "", subtitle: "")
        
        let gridStyle = GridStyle(lineColour: .neutral.axis,
                                  lineWidth: 3,
                                  dash: []
        )
        
        let chartStyle = LineChartStyle(infoBoxPlacement: .floating,
                                         markerType: .full(attachment: .line(dot: .style(DotStyle()))),
                                        xAxisGridStyle: gridStyle
        )
        
        return LineChartData(dataSets: chartData,
                             metadata: metadata,
                             chartStyle: chartStyle
        )
    }
}

struct AnalyticsChart_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsChart(title: "Dynamic",
                       descriptiveText: "Attack, Sustain, Release, Decay",
                       data: [2, 1, 5, 3, 2],
                       legend: "Amplitude")
            .environmentObject(AudioViewModel())
    }
}
