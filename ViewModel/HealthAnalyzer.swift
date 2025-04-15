//
//  HealthAnalyzer.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.

import SwiftUI
import Foundation
import UserNotifications

class HealthAnalyzer: ObservableObject {
    @Published var healthScore: Double = 0
    @Published var regularityLevel: HealthStatus = .normal
    @Published var stoolTypeLevel: HealthStatus = .normal
    @Published var healthTips: [String] = []
    
    var regularityStatus: String {
        switch regularityLevel {
        case .good: return "good-regular"
        case .normal: return "normal-regular"
        case .warning: return "warn-regular"
        case .alert: return "alert-regular"
        }
    }
    
    var stoolTypeStatus: String {
        switch stoolTypeLevel {
        case .good: return "good-stool"
        case .normal: return "normal-stool"
        case .warning: return "warn-stool"
        case .alert: return "alert-stool"
        }
    }
    
    func analyzeHealth(records: [Record]) {
        analyzeRegularity(records)
        analyzeStoolType(records)
        generateHealthTips()
        calculateOverallScore()
    }
    
    private func analyzeRegularity(_ records: [Record]) {
        
        let calendar = Calendar.current
        let today = Date()
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: today)!
        
        let recentRecords = records.filter {
            $0.date >= lastWeek && $0.date <= today
        }
        
        
        let dailyRecords = Dictionary(grouping: recentRecords) { record in
            calendar.startOfDay(for: record.date)
        }
        
        
        let regularityScore = Double(dailyRecords.count) / 7.0
        regularityLevel = regularityScore >= 0.8 ? .good :
                         regularityScore >= 0.6 ? .normal :
                         regularityScore >= 0.4 ? .warning : .alert
    }
    
    private func analyzeStoolType(_ records: [Record]) {
        let recentRecords = records.suffix(10)
        let healthyTypes: Set<Record.BristolType> = [.type3, .type4]
        let okayTypes: Set<Record.BristolType> = [.type2, .type5]
        
        var healthyCount = 0
        var okayCount = 0
        var totalCount = 0
        
        for record in recentRecords {
            if let stool = record.stoolCondition {
                totalCount += 1
                if healthyTypes.contains(stool.type) {
                    healthyCount += 1
                } else if okayTypes.contains(stool.type) {
                    okayCount += 1
                }
            }
        }
        
        if totalCount > 0 {
            let healthScore = Double(healthyCount + okayCount) / Double(totalCount)
            stoolTypeLevel = healthScore >= 0.8 ? .good :
                           healthScore >= 0.6 ? .normal :
                           healthScore >= 0.4 ? .warning : .alert
        }
    }
    
    private func generateHealthTips() {
        healthTips.removeAll()
        
        
        switch regularityLevel {
        case .good:
            healthTips.append("good job!")
        case .normal:
            healthTips.append("normal, keep it up!")
        case .warning:
            healthTips.append("⚠️ is unregular, \n- tip：\n- keep a regular schedule\n- pay attention to diet\n- exercise regularly")
        case .alert:
            healthTips.append("❗️not good，tips：\n- improve sleep habits\n- do more exercise\n- pay attention to diet\n- consult a doctor")
        }
        
        
        switch stoolTypeLevel {
        case .good:
            healthTips.append("your poop is a good poop！")
        case .normal:
            healthTips.append("ennn,normal poop!normal is best right?")
        case .warning:
            healthTips.append("⚠️ you need pay attention to：\n- add more fiber to your diet\n- make sure you drink enough water")
        case .alert:
            healthTips.append("❗️oh no! your poop is not good，plz pay attention to：\n- avoid sugary and fatty foods\n- drink more water\n- if it persists, consult a doctor")
        }
    }
    
    private func calculateOverallScore() {
        
        let regularityScore: Double = switch regularityLevel {
            case .good: 40
            case .normal: 30
            case .warning: 20
            case .alert: 10
        }
        
        
        let stoolTypeScore: Double = switch stoolTypeLevel {
            case .good: 40
            case .normal: 30
            case .warning: 20
            case .alert: 10
        }
        
        
        let baseScore: Double = 20
        
        
        healthScore = regularityScore + stoolTypeScore + baseScore
    }
}
