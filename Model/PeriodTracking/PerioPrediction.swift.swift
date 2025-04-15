//
//  PerioPrediction.swift.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
import SwiftUI
import Foundation 

// PeriodPrediction.swift
struct PeriodPrediction {
    let startDate: Date
    let predictedEndDate: Date
    let confidence: Double
    
    var duration: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: predictedEndDate).day ?? 0
    }
}
