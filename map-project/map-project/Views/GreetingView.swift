//
//  GreetingView.swift
//  map-project
//
//  Created by Brajan Kukk on 02.01.2025.
//
import SwiftUI

public struct GreetingView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isVisible = false
    @State private var shineOffset: CGFloat = -1.0
    @State private var isAnimating = false

    public var body: some View {
        ZStack {
            themeManager.currentTheme.primaryGradient
            BackGround(image: "HikingGreeting", maxHeight: 450)
                .environmentObject(themeManager)

            VStack {
                Spacer(minLength: 450)

                // Regular text
                Text("Hike, Jog or orient ")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.currentTheme.textColor)

                // Gradient-styled text
                HStack {
                    Text("with")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Text("TwiHiker")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.clear)
                        .overlay(
                            themeManager.currentTheme.buttonGradient
                            .mask(
                                Text("TwiHiker")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                            )
                        )
                }
                Text("TwiHiker has everything you need to record hikes, jogs or orienteerings. You can record, delete, continue and export all your past hikes, jogs or orienteering sessions.")
                    .padding(.bottom, 30)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .font(.system(size: 18, weight: .medium, design: .rounded))

                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Adjust delay as needed
                        withAnimation {
                            isVisible = false
                        }
                    }
                }) {
                    ZStack {
                        // Background gradient
                        themeManager.currentTheme.buttonGradient
                        .cornerRadius(30)
                        
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.8), Color.white.opacity(0.4)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .cornerRadius(30)
                        .rotationEffect(.degrees(120)) // Rotate for diagonal effect
                        .offset(x: shineOffset * 300) // Adjust based on button width
                        .mask(
                            RoundedRectangle(cornerRadius: 30)
                                .frame(height: 60) // Match button height
                        )
                    }
                    .frame(height: 60) // Button height
                    .overlay(
                        Text("Get started")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.currentTheme.textColor)
                    )
                }
                .padding(.horizontal, 30)

                Spacer()
            }
        }
        .opacity(isVisible ? 1 : 0) // Fade effect
        .animation(.easeInOut(duration: 2), value: isVisible) // Smooth animation
        .onAppear {
            // Start with fade-in
            withAnimation {
                isVisible = true
            }

            // Start shine animation with delay
            startShineAnimation()
        }
    }

    private func startShineAnimation() {
        withAnimation(.linear(duration: 2)) {
            shineOffset = 2.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // 2.5 seconds delay after the animation ends
            shineOffset = -1.0 // Reset position
            startShineAnimation() // Restart animation
        }
    }
}

#Preview {
    GreetingView()
        .environmentObject(ThemeManager())
}
