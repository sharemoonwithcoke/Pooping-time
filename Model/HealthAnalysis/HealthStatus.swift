//
//  HealthStatus.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.

import SwiftUI
import Foundation

enum HealthStatus: String {
    case good = "good"
    case normal = "normal"
    case warning = "warnning"
    case alert = "alert"
    
    var color: Color {
        switch self {
        case .good: return .green
        case .normal: return .blue
        case .warning: return .orange
        case .alert: return .red
        }
    }
}


struct HealthRisk: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let level: HealthStatus
    let date: Date
    var recommendations: [String]
}

struct HealthMetrics {
    let regularityScore: Double
    let consistencyScore: Double
    let durationScore: Double
    let overallScore: Double
    
    var status: HealthStatus {
        switch overallScore {
        case 80...100: return .good
        case 60..<80: return .normal
        case 40..<60: return .warning
        default: return .alert
        }
    }
}
