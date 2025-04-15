//
//  PeriodCycleView.swift .swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import SwiftUI
import Foundation
import Charts

struct PeriodCycleView: View {
    let data: [StatisticsViewModel.PeriodPoint]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("period cycle")
                .font(.headline)
            
            Chart {
                ForEach(data) { point in
                    RectangleMark(
                        x: .value("date", point.date),
                        y: .value("intensity", point.intensity)
                    )
                    .foregroundStyle(.pink.opacity(0.6))
                }
            }
            .frame(height: 100)
        }
        .padding()
        .handDrawnFrame()
    }
}
