//
//  CycleMetrics.swift
//  Pooping-time
//
//  Created by yueming on 2/11/25.
//
import Foundation

// CycleMetrics.swift
struct CycleMetrics {
    var averageCycleLength: Int
    var averagePeriodLength: Int
    var cycleRegularity: Double  
    var lastPeriodStart: Date?
    var lastPeriodEnd: Date?
    
    init(averageCycleLength: Int = 28,
         averagePeriodLength: Int = 5,
         cycleRegularity: Double = 0.0,
         lastPeriodStart: Date? = nil,
         lastPeriodEnd: Date? = nil) {
        self.averageCycleLength = averageCycleLength
        self.averagePeriodLength = averagePeriodLength
        self.cycleRegularity = cycleRegularity
        self.lastPeriodStart = lastPeriodStart
        self.lastPeriodEnd = lastPeriodEnd
    }
    
    var isRegular: Bool {
        return cycleRegularity >= 0.8
    }
}

struct CycleData: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let flow: Record.PeriodFlow
    let symptoms: [String]
    
    var duration: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
}
