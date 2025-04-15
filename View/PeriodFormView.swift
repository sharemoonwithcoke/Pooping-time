//
//  PeriodFormView.swift
//  Pooping-time
//
//  Created by yueming on 2/11/25.
//



import SwiftUI

struct PeriodFormView: View {
    @Binding var periodDay: Int
    @Binding var periodFlow: Record.PeriodFlow
    @Binding var periodNote: String
    let onNext: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("the day")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Stepper("the \(periodDay) day", value: $periodDay, in: 1...7)
                        .padding()
                }
                .handDrawnFrame()
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("flow")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(Record.PeriodFlow.allCases, id: \.self) { flow in
                                RadioIconButton(
                                    imageName: getPeriodFlowIconName(flow),
                                    label: flow.rawValue,
                                    isSelected: periodFlow == flow
                                ) {
                                    periodFlow = flow
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .handDrawnFrame()
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("note")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextField("note", text: $periodNote)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                .handDrawnFrame()
                
                
                Button(action: onNext) {
                    Text("Record completion")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
    
    private func getPeriodFlowIconName(_ flow: Record.PeriodFlow) -> String {
        switch flow {
        case .light: return "period_light_icon"
        case .medium: return "period_medium_icon"
        case .heavy: return "period_heavy_icon"
        }
    }
}
