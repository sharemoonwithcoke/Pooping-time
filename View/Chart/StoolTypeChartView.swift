//
//  StoolTypeChartView.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import SwiftUI
import Foundation
import Charts


struct StoolTypeChartView: View {
    let data: [StatisticsViewModel.StoolTypePoint]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("poop type")
                .font(.headline)
            
            Chart {
                ForEach(data) { point in
                    SectorMark(
                        angle: .value("count", point.count),
                        innerRadius: .ratio(0.6),
                        angularInset: 1
                    )
                    .foregroundStyle(by: .value("type", point.type.description))
                }
            }
            .frame(height: 200)
        }
        .padding()
        .handDrawnFrame()
    }
}
