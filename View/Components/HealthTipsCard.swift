//
//  HealthTipsCard.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
//
import Charts
import SwiftUICore
import SwiftUI

// Components/HealthTipsCard.swift
struct HealthTipsCard: View {
    let tips: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tips")
                .font(.headline)
            
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                    Text(tip)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .handDrawnFrame()
    }
}
