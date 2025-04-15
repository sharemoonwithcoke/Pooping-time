//
//  HealthScoreCard.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import Charts
import SwiftUICore
import SwiftUI


struct HealthScoreCard: View {
    let score: Double
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 15)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: score / 100)
                    .stroke(Color.blue, lineWidth: 15)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(score))")
                        .font(.system(size: 40, weight: .bold))
                    Text("Score of health")
                        .font(.subheadline)
                }
            }
        }
        .handDrawnFrame()
    }
}
