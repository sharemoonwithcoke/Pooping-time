//
//  Date+Extensions.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
import SwiftUI
import Foundation
import UserNotifications
extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

extension Color {
    static let customBackground = Color("BackgroundColor")
    static let customAccent = Color("AccentColor")
    
    static func healthStatus(_ status: HealthStatus) -> Color {
        switch status {
        case .good: return .green
        case .normal: return .blue
        case .warning: return .orange
        case .alert: return .red
        }
    }
}


struct ChartDataFormatter {
    static func formatFrequencyData(_ records: [Record]) -> [StatisticsViewModel.FrequencyPoint] {
      
        return []
    }
    
    static func formatStoolTypeData(_ records: [Record]) -> [StatisticsViewModel.StoolTypePoint] {
        
        return []
    }
    
    static func formatPeriodData(_ records: [Record]) -> [StatisticsViewModel.PeriodPoint] {
        return []
    }
}


enum HealthConstants {
    static let normalCycleLength = 28
    static let normalPeriodLength = 5
    static let maxCycleLength = 35
    static let minCycleLength = 21
    
    static let healthTipCategories = [
        "regular": ["keep regular routine.", "Regular toileting", "Exercise on Schedule"],
        "diet": ["Drink more water.", "Eat more fiber", "less greasy"],
        "exercise": ["30 minutes of exercise", "Don't stay sedentary", "Hula hooping!"]
    ]
}
