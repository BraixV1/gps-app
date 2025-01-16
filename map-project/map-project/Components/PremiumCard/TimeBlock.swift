//
//  TimeBLock.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct TimeBlock: View {
    let value: Int
    let label: String
    let theme: Theme
    let isAnimating: Bool
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(String(format: "%02d", value))")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(theme.textColor)
                .frame(minWidth: 40)
                .contentTransition(.numericText())
                .scaleEffect(scale)
                .animation(.interpolatingSpring(duration: 0.2), value: value)
                .onChange(of: value) { _ in
                    scale = 1.2
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        scale = 1.0
                    }
                }
            
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(theme.textColor.opacity(0.7))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.buttonGradient.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(theme.textColor.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: theme.textColor.opacity(isAnimating ? 0.2 : 0), radius: 8, x: 0, y: 4)
        )
    }
}
