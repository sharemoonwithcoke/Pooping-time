//
//  StatisticsView.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.

import SwiftUI
import OSLog
import Foundation

struct StatisticsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel: StatisticsViewModel
    @State private var selectedAnalysis: AnalysisType = .trends
    
    enum AnalysisType {
        case trends
        case health
        case period
    }
    
    init(userGender: Gender) {
        _viewModel = StateObject(wrappedValue: StatisticsViewModel(userGender: userGender))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Picker("select analysis", selection: $selectedAnalysis) {
                        Text("Analysis type").tag(AnalysisType.trends)
                        Text("health analysis").tag(AnalysisType.health)
                        if userViewModel.userProfile.gender == .female {
                            Text("period analysis").tag(AnalysisType.period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    
                    VStack(spacing: 20) {
                        switch selectedAnalysis {
                        case .trends:
                            VStack(spacing: 20) {
                                OverallStatsView(viewModel: viewModel)
                                HandDrawnDivider()
                                WeeklyStatsView(stats: viewModel.last7DaysStats)
                                HandDrawnDivider()
                                TypeDistributionView(distribution: viewModel.bristolTypeDistribution)
                            }
                        case .health:
                            HealthAnalysisView(analyzer: viewModel.healthAnalyzer)
                        case .period:
                            if userViewModel.userProfile.gender == .female,
                               let periodTracker = viewModel.periodTracker {
                                PeriodTrackingView(tracker: periodTracker)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("health")
            .onAppear {
                viewModel.updateStatistics()
            }
        }
    }
}


struct OverallStatsView: View {
    let viewModel: StatisticsViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            StatCard(
                title: "total records",
                value: "\(viewModel.totalRecords) time",
                icon: "list.bullet.clipboard"
            )
            
            StatCard(
                title: "average time",
                value: formatDuration(viewModel.averageDuration),
                icon: "clock"
            )
        }
        .handDrawnFrame()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d min %d Sec", minutes, seconds)
    }
}


struct WeeklyStatsView: View {
    let stats: [Date: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("per week")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(stats.sorted(by: { $0.key > $1.key }), id: \.key) { date, count in
                HStack {
                    Text(formatDate(date))
                    Spacer()
                    Text("\(count) time")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
        }
        .handDrawnFrame()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: date)
    }
}


struct TypeDistributionView: View {
    let distribution: [Record.BristolType: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("poop type")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(Record.BristolType.allCases) { type in
                HStack {
                    Text(type.description)
                        .font(.subheadline)
                    Spacer()
                    Text("\(distribution[type] ?? 0) time")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
        }
        .handDrawnFrame()
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
        }
        .padding()
    }
}
