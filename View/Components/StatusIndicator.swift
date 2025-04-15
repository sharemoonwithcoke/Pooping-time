//
//  StatusIndicator.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import Charts
import SwiftUICore
import SwiftUI


// Components/StatusIndicator.swift
struct StatusIndicator: View {
    let level: HealthStatus
    
    var body: some View {
        Circle()
            .fill(level.color)
            .frame(width: 12, height: 12)
    }
}
