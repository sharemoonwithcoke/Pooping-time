//
//  PeriodTracker.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25
//
import SwiftUI
import Foundation
import UserNotifications



class PeriodTracker: ObservableObject {
    @Published var cycleMetrics: CycleMetrics
    @Published var predictions: [PeriodPrediction] = []
    @Published var currentCycle: CycleData?
    @Published var periodData: [StatisticsViewModel.PeriodPoint] = []
    
    private let calendar = Calendar.current
    
    init() {
        self.cycleMetrics = CycleMetrics(
            averageCycleLength: 28,
            averagePeriodLength: 5,
            cycleRegularity: 0.0
        )
        loadData()
        updatePeriodData()
    }
    
    func predictNextPeriod() -> PeriodPrediction? {
        guard let lastPeriod = cycleMetrics.lastPeriodStart else { return nil }
        
        let predictedStart = calendar.date(
            byAdding: .day,
            value: cycleMetrics.averageCycleLength,
            to: lastPeriod
        )!
        
        let predictedEnd = calendar.date(
            byAdding: .day,
            value: cycleMetrics.averagePeriodLength,
            to: predictedStart
        )!
        
        return PeriodPrediction(
            startDate: predictedStart,
            predictedEndDate: predictedEnd,
            confidence: cycleMetrics.cycleRegularity
        )
    }
    
    func scheduleNotifications() {
        guard let prediction = predictNextPeriod() else { return }
        
        let reminderDate = calendar.date(
            byAdding: .day,
            value: -3,
            to: prediction.startDate
        )!
        
        setupNotification(for: reminderDate)
    }
    
    private func updatePeriodData() {
        let records = DataManager.shared.records
        
        periodData = records
            .compactMap { record -> StatisticsViewModel.PeriodPoint? in
                guard let period = record.periodCondition else { return nil }
                
                let intensity: Double
                switch period.flow {
                case .heavy:
                    intensity = 1.0
                case .medium:
                    intensity = 0.7
                case .light:
                    intensity = 0.4
                }
                
                return StatisticsViewModel.PeriodPoint(
                 
                    date: record.date,
                    intensity: intensity
                )
            }
           
            .sorted { $0.date > $1.date }
            
        
        if let firstDate = periodData.last?.date,
           let lastDate = periodData.first?.date {
            let days = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
            let cycles = max(1, periodData.count - 1)
            cycleMetrics.averageCycleLength = days / cycles
            
            
            let cycleLengths = calculateCycleLengths()
            cycleMetrics.cycleRegularity = calculateRegularity(cycleLengths)
        }
    }

        private func calculateCycleLengths() -> [Int] {
        guard periodData.count >= 2 else { return [] }
        
        var cycleLengths: [Int] = []
        for i in 0..<(periodData.count - 1) {
            let days = Calendar.current.dateComponents(
                [.day],
                from: periodData[i + 1].date,
                to: periodData[i].date
            ).day ?? 0
            cycleLengths.append(days)
        }
        return cycleLengths
    }

    
    private func calculateRegularity(_ cycleLengths: [Int]) -> Double {
        guard !cycleLengths.isEmpty else { return 0.0 }
        
        let average = Double(cycleLengths.reduce(0, +)) / Double(cycleLengths.count)
        let maxVariance = 5.0
        
        
        let deviations = cycleLengths.map { abs(Double($0) - average) }
        
        
        let regularity = deviations.map { 1.0 - min($0, maxVariance) / maxVariance }
        
        
        return regularity.reduce(0.0, +) / Double(regularity.count)
    }
    
    private func setupNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Period Reminder"
        content.body = "Your period may be about to begin"
        content.sound = .default
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func loadData() {
        let records = DataManager.shared.records
            .filter { $0.periodCondition != nil }
            .sorted { $0.date > $1.date }
        
        if let lastRecord = records.first {
            
            cycleMetrics.lastPeriodStart = lastRecord.date
            
            
            let possibleEndDate = records
                .filter { $0.date <= lastRecord.date }
                .first { record in
                    let dayDiff = Calendar.current.dateComponents([.day],
                                                               from: lastRecord.date,
                                                               to: record.date).day ?? 0
                    return abs(dayDiff) >= cycleMetrics.averagePeriodLength
                }?.date
            
            cycleMetrics.lastPeriodEnd = possibleEndDate
        }
        
        
        updatePeriodData()
    }
    
    func updateMetrics() {
        
        updatePeriodData()
    }
}

