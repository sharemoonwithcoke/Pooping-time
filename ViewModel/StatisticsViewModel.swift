//
//StatisticsViewModel.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.

import Foundation
import SwiftUI
import Combine



class StatisticsViewModel: ObservableObject {
    
    @Published var totalRecords: Int = 0
    @Published var averageDuration: TimeInterval = 0
    @Published var last7DaysStats: [Date: Int] = [:]
    @Published var bristolTypeDistribution: [Record.BristolType: Int] = [:]
    
    
    @Published var healthAnalyzer = HealthAnalyzer()
    @Published var periodTracker: PeriodTracker?
    
    
    @Published var frequencyData: [FrequencyPoint] = []
    @Published var stoolTypeData: [StoolTypePoint] = []
    @Published var durationData: [DurationPoint] = []
    @Published var periodData: [PeriodPoint] = []
    
    private let dataManager = DataManager.shared
    private let userGender: Gender
    private var cancellables = Set<AnyCancellable>()
    
   
    struct FrequencyPoint: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }
    
    struct StoolTypePoint: Identifiable {
        let id = UUID()
        let type: Record.BristolType
        let count: Int
    }
    
    struct DurationPoint: Identifiable {
        let id = UUID()
        let date: Date
        let duration: TimeInterval
    }
    
    struct PeriodPoint: Identifiable {
        let id = UUID()
        let date: Date
        let intensity: Double
    }
    
    init(userGender: Gender) {
        self.userGender = userGender
        if userGender == .female {
            self.periodTracker = PeriodTracker()
        }
        updateStatistics()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        dataManager.$records
            .sink { [weak self] _ in
                self?.updateStatistics()
            }
            .store(in: &cancellables)
    }
    
    func updateStatistics() {
        let records = dataManager.records
        
        
        updateBasicStatistics(records)
        
        
        updateChartData(records)
        
        
        healthAnalyzer.analyzeHealth(records: records)
        
        
        if userGender == .female {
            periodTracker?.updateMetrics()
        }
    }
    
    
    private func updateBasicStatistics(_ records: [Record]) {
        totalRecords = records.filter { $0.stoolCondition != nil }.count
        
        let validRecords = records.filter { $0.duration > 0 }
        let totalDuration = validRecords.reduce(0) { $0 + $1.duration }
        averageDuration = validRecords.isEmpty ? 0 : totalDuration / Double(validRecords.count)
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let last7Days = (0..<7).map { calendar.date(byAdding: .day, value: -$0, to: today)! }
        
        last7DaysStats = Dictionary(uniqueKeysWithValues: last7Days.map { date in
            let count = records.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
            return (date, count)
        })
        
        bristolTypeDistribution = Dictionary(grouping: records.compactMap { $0.stoolCondition?.type }) { $0 }
            .mapValues { $0.count }
    }
    
    private func updateChartData(_ records: [Record]) {
        
        frequencyData = last7DaysStats.map { date, count in
            FrequencyPoint(date: date, count: count)
        }.sorted { $0.date < $1.date }
        
       
        stoolTypeData = bristolTypeDistribution.map { type, count in
            StoolTypePoint(type: type, count: count)
        }
        
        
        durationData = records
            .filter { $0.duration > 0 }
            .map { DurationPoint(date: $0.date, duration: $0.duration) }
            .sorted { $0.date < $1.date }
        
        
        if userGender == .female {
            updatePeriodData(records)
        }
    }
    
    private func updatePeriodData(_ records: [Record]) {
        periodData = records
            .compactMap { record -> PeriodPoint? in
                guard let period = record.periodCondition else { return nil }
                return PeriodPoint(
                    date: record.date,
                    intensity: Double(period.flow == .heavy ? 1.0 :
                                   period.flow == .medium ? 0.7 : 0.4)
                )
            }
            .sorted { $0.date < $1.date }
    }
}
