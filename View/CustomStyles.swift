//CustomStyle.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.

import SwiftUI

struct HandDrawnButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color, lineWidth: 3)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(configuration.isPressed ? color.opacity(0.1) : .clear)
                    )
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            )
    }
}

struct HandDrawnFrameStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 3)
                    .background(Color.white)
            )
            .padding(.horizontal)
    }
}

struct HandDrawnDivider: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addCurve(
                    to: CGPoint(x: geometry.size.width - 40, y: 0),
                    control1: CGPoint(x: geometry.size.width * 0.3, y: 5),
                    control2: CGPoint(x: geometry.size.width * 0.6, y: -5)
                )
            }
            .stroke(Color.black, lineWidth: 2)
        }
        .frame(height: 10)
        .padding(.horizontal, 20)
    }
}

extension View {
    func handDrawnFrame() -> some View {
        modifier(HandDrawnFrameStyle())
    }
}
