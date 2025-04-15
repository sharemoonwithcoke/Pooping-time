//
//  FrequencyChartView.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
///
import SwiftUI
import Foundation
import Charts

struct FrequencyChartView: View {
    let data: [StatisticsViewModel.FrequencyPoint]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("pee frequency")
                .font(.headline)
            
            Chart {
                ForEach(data) { point in
                    BarMark(
                        x: .value("date", point.date),
                        y: .value("count", point.count)
                    )
                    .foregroundStyle(Color.blue.gradient)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day())
                }
            }
        }
        .padding()
        .handDrawnFrame()
    }
}




