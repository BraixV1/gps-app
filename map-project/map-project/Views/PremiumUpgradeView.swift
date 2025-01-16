//
//  PremiumUpgradeView.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct PremiumUpgradeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var themeManager: ThemeManager
    let theme: Theme
    @State private var selectedPlan: SubscriptionPlan = .annual
    @State private var showSuccessAnimation = false
    @State private var shineOffset: CGFloat = -1.0
    
    enum SubscriptionPlan {
        case monthly, annual
    }
    
    var body: some View {
        ZStack {
            
            ZStack {
                
                theme.primaryGradient
                    .ignoresSafeArea()
                ConfettiView(effect: theme.confettiEffect)
                    .allowsHitTesting(!showSuccessAnimation)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with Trial Badge
                        VStack(spacing: 8) {
                            Text("✨ TwiHiker Pro ✨")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(theme.textColor)
                            
                            FreeTrialBadge(theme: theme)
                                .padding(.top, 4)
                            
                            TrialCountdownTimer(theme: theme)
                                .padding(.horizontal)
                            
                            Text("Unlock Your Full Hiking Journey")
                                .font(.headline)
                                .foregroundColor(theme.textColor.opacity(0.9))
                        }
                        
                        // Trial Info Card
                        TrialInfoCard(theme: theme)
                            .padding(.horizontal)
                        
                        // Features
                        VStack(spacing: 16) {
                            FeatureRow(icon: "paintpalette.fill", text: "Premium Themes & Customization")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Advanced Statistics")
                            FeatureRow(icon: "map.fill", text: "Detailed Route Analysis")
                            FeatureRow(icon: "icloud.fill", text: "Unlimited Cloud Backup")
                        }
                        .padding(.vertical)
                        
                        // Pricing Plans
                        VStack(spacing: 16) {
                            Text("Select Your Plan After Trial")
                                .font(.headline)
                                .foregroundColor(theme.textColor)
                            
                            // Annual Plan
                            PlanCard(
                                isSelected: selectedPlan == .annual,
                                title: "Annual Plan",
                                price: "4.99",
                                billingPeriod: "per month",
                                savings: "Save 38%",
                                theme: theme,
                                action: { selectedPlan = .annual }
                            )
                            
                            // Monthly Plan
                            PlanCard(
                                isSelected: selectedPlan == .monthly,
                                title: "Monthly Plan",
                                price: "7.99",
                                billingPeriod: "per month",
                                theme: theme,
                                action: { selectedPlan = .monthly }
                            )
                        }
                        .padding(.horizontal)
                        
                        // Total price information
                        Group {
                            if selectedPlan == .annual {
                                Text("€59.88 billed annually after trial")
                                    .font(.subheadline)
                                    .foregroundColor(theme.textColor.opacity(0.8))
                            } else {
                                Text("€7.99 billed monthly after trial")
                                    .font(.subheadline)
                                    .foregroundColor(theme.textColor.opacity(0.8))
                            }
                        }
                        
                        // Start Trial Button
                        Button(action: {
                            // Add your in-app purchase logic here
                            startFreeTrial()
                        }) {
                            ZStack {
                                // Background gradient (static part of the button)
                                theme.buttonGradient
                                    .cornerRadius(30)
                                    .shadow(radius: 5)

                                // Shine effect
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.8),
                                        Color.white.opacity(0.3)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .rotationEffect(.degrees(20)) // Diagonal effect
                                .offset(x: shineOffset * 350) // Adjust for button width
                                .mask(
                                    RoundedRectangle(cornerRadius: 30)
                                        .frame(height: 55) // Match button height
                                )
                            }
                            .overlay(
                                Text("Start 7-Day Free Trial")
                                    .font(.headline)
                                    .foregroundColor(theme.textColor)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            )
                        }
                        .frame(height: 60) // Button height
                        .padding(.horizontal, 24)
                        .onAppear {
                            startShineAnimation()
                        }

                        .padding(.horizontal, 24)
                        .padding(.top)
                        
                        // Trial Terms
                        VStack(spacing: 8) {
                            Text("Try All Pro Features Free for 7 Days")
                                .font(.subheadline)
                                .foregroundColor(theme.textColor)
                            
                            Text("Cancel anytime during trial • No charges until trial ends")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .foregroundColor(theme.textColor.opacity(0.8))
                        }
                        
                        // Dismiss button
                        Button("Maybe Later") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(theme.textColor.opacity(0.7))
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
            .onAppear {
                startShineAnimation()
            }
            .allowsHitTesting(!showSuccessAnimation)
                        
                        // Success animation overlay
                        if showSuccessAnimation {
                            SuccessAnimation(isShowing: $showSuccessAnimation, theme: theme) {
                                // This will be called when animation completes
                                user.hasPro = true
                                dismiss()
                            }
                            .transition(.opacity)
                        }
        }
    }
    
    private func startShineAnimation() {
        withAnimation(.linear(duration: 2)) {
            shineOffset = 2.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            shineOffset = -1.0 // Reset position
            startShineAnimation() // Restart animation
        }
    }

    
    private func startFreeTrial() {
        showSuccessAnimation = true
    }
}
