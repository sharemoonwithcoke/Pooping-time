//
//  RegularityAnalysisCard.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import Charts
import SwiftUICore
import SwiftUI


// Components/RegularityAnalysisCard.swift
struct RegularityAnalysisCard: View {
    let status: String
    let level: HealthStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(level.color)
                Text("poop regularity")
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
