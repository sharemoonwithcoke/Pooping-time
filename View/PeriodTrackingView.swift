//
//  PeriodTrackingView.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import SwiftUI

struct StatItem: View {
    let title: String
    let value: String
    var unit: String? = nil
    var color: Color? = nil
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color ?? .primary)
                
                if let unit = unit {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}


struct PeriodTrackingView: View {
    let tracker: PeriodTracker

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let prediction = tracker.predictNextPeriod() {
                    PeriodPredictionCard(prediction: prediction)
                }
                
                HandDrawnDivider()
                
                PeriodStatsCard(cycleMetrics: tracker.cycleMetrics)
                
                HandDrawnDivider()
                
                PeriodHistoryView(cycles: tracker.periodData)
            }
            .padding()
            .frame(minWidth: 300, maxWidth: .infinity)
            .frame(minHeight: 600)
        }
    }
}


struct PeriodPredictionCard: View {
    let prediction: PeriodPrediction?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Next Period Prediction")
                .font(.headline)
            
            if let prediction = prediction {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Next Period：")
                            .font(.subheadline)
                        Text(formatDate(prediction.startDate))
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("will be in：")
                            .font(.subheadline)
                        Text("the \(daysUntil(prediction.startDate)) day")
                            .font(.title2)
                            .bold()
                    }
                }
            } else {
                Text("oh,we need more data to make prediction")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .handDrawnFrame()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
    private func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}


struct PeriodStatsCard: View {
    let cycleMetrics: CycleMetrics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("cycle metrics")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack(spacing: 20) {
                StatItem(
                    title: "average cycle",
                    value: "\(cycleMetrics.averageCycleLength)",
                    unit: "day"
                )
                
                StatItem(
                    title: "average period",
                    value: "\(cycleMetrics.averagePeriodLength)",
                    unit: "day"
                )
                
                StatItem(
                    title: "regular",
                    value: cycleMetrics.isRegular ? "regular" : "unregular",
                    color: cycleMetrics.isRegular ? .green : .orange
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .handDrawnFrame()
    }
}


struct PeriodHistoryView: View {
    let cycles: [StatisticsViewModel.PeriodPoint]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("your period history")
                .font(.headline)
                .padding(.bottom, 4)
            
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(cycles) { cycle in
                        HStack {
                            Text(formatDate(cycle.date))
                                .font(.caption)
                            
                            Spacer()
                            
                            IntensityIndicator(intensity: cycle.intensity)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(4)
                    }
                }
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .handDrawnFrame()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}


struct IntensityIndicator: View {
    let intensity: Double
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(index < Int(intensity * 3) ? Color.pink : Color.gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }
}
