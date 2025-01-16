//
//  TrialCountdownTimer 2.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct TrialCountdownTimer: View {
    let theme: Theme
    @StateObject private var timerState = TimerState()
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Animated offer text
            Text("Limited Time Offer")
                .font(.subheadline)
                .foregroundColor(theme.textColor.opacity(0.8))
                .modifier(ShimmerEffect(theme: theme))
            
            HStack(spacing: 16) {
                TimeBlock(value: days, label: "DAYS", theme: theme, isAnimating: isAnimating)
                ColonDivider(theme: theme)
                TimeBlock(value: hours, label: "HOURS", theme: theme, isAnimating: isAnimating)
                ColonDivider(theme: theme)
                TimeBlock(value: minutes, label: "MIN", theme: theme, isAnimating: isAnimating)
                ColonDivider(theme: theme)
                TimeBlock(value: seconds, label: "SEC", theme: theme, isAnimating: isAnimating)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.buttonGradient.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(theme.textColor.opacity(0.1), lineWidth: 1)
                        .blur(radius: isAnimating ? 3 : 0)
                )
        )
        .onAppear {
            timerState.isActive = true
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
        .onDisappear {
            timerState.isActive = false
        }
    }
    
    private var days: Int {
        Int(timerState.timeRemaining) / (24 * 3600)
    }
    
    private var hours: Int {
        (Int(timerState.timeRemaining) % (24 * 3600)) / 3600
    }
    
    private var minutes: Int {
        (Int(timerState.timeRemaining) % 3600) / 60
    }
    
    private var seconds: Int {
        Int(timerState.timeRemaining) % 60
    }
}
