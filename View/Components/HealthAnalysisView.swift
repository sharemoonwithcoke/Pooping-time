//
//  HealthAnalysisView.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
import Charts
import SwiftUICore
import SwiftUI

struct HealthAnalysisView: View {
    @ObservedObject var analyzer: HealthAnalyzer
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HealthScoreCard(score: analyzer.healthScore)
                
                RegularityAnalysisCard(
                    status: analyzer.regularityStatus,
                    level: analyzer.regularityLevel
                )
                
                StoolTypeAnalysisCard(
                    status: analyzer.stoolTypeStatus,
                    level: analyzer.stoolTypeLevel
                )
                
                if !analyzer.healthTips.isEmpty {
                    HealthTipsCard(tips: analyzer.healthTips)
                }
            }
            .padding()
        }
    }
}









