//
//  StoolTypeAnalysisCard.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import Charts
import SwiftUICore
import SwiftUI


// Components/StoolTypeAnalysisCard.swift
struct StoolTypeAnalysisCard: View {
    let status: String
    let level: HealthStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "chart.pie")
                    .foregroundColor(level.color)
                Text("poop type")
                    .font(.headline)
                Spacer()
                StatusIndicator(level: level)
            }
            
            Text(status)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .handDrawnFrame()
    }
}
