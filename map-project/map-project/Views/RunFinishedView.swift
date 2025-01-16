//
//  RunFinished.swift
//  map-project
//
//  Created by Brajan Kukk on 02.01.2025.
//

import SwiftUI
import SwiftData

struct RunFinishedView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var repository: LoginDataRepository
    
    @State private var showCircle = false
    @State private var showDetails = false
    @State private var currentTime: TimeInterval = 0
    @State private var showPremiumUpgrade = false
    
    let checkpoints: Int
    let distance: Double
    let totalTime: TimeInterval
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.primaryGradient
                .ignoresSafeArea()
            
            ConfettiView(effect: themeManager.currentTheme.confettiEffect)
            VStack {
                ScrollView {
                    VStack(spacing: 40) {
                        // Timer Circle
                        ZStack {
                            Circle()
                                .trim(from: 0, to: showCircle ? 1 : 0)
                                .stroke(themeManager.currentTheme.primaryColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 3), value: showCircle)
                            
                            Text(formatTime(currentTime))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundColor(themeManager.currentTheme.textColor)
                        }
                        
                        // Basic Stats
                        if showDetails {
                            VStack(spacing: 20) {
                                Text("🎉 Congratulations!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(themeManager.currentTheme.textColor)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    StatsCard(
                                        title: "Checkpoints",
                                        value: "\(checkpoints)",
                                        theme: themeManager.currentTheme
                                    )
                                    
                                    StatsCard(
                                        title: "Distance",
                                        value: String(format: "%.2f km", locationViewModel.calculateTotalDistance() / 1000),
                                        theme: themeManager.currentTheme
                                    )
                                    
                                    StatsCard(
                                        title: "Average Pace",
                                        value: locationViewModel.calculateWaypointPace() ?? "N/A",
                                        theme: themeManager.currentTheme
                                    )
                                    
                                    StatsCard(
                                        title: "Active Time",
                                        value: formatTime(locationViewModel.calculateActiveDuration()),
                                        theme: themeManager.currentTheme
                                    )
                                }
                            }
                            .transition(.opacity)
                            .animation(.easeIn(duration: 1), value: showDetails)
                            
                            // Advanced Stats (Pro Feature)
                            ZStack {
                                AdvancedStatsSection(theme: themeManager.currentTheme)
                                    .environmentObject(locationViewModel)
                                    .environmentObject(user)
                                    .blur(radius: user.hasPro ? 0 : 6)
                                
                                if !user.hasPro {
                                    PremiumOverlay(theme: themeManager.currentTheme) {
                                        showPremiumUpgrade = true
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    .padding()

                }
                BottomNavBar()
                    .environmentObject(user)
                    .environmentObject(themeManager)
                    .environmentObject(locationViewModel)
                    .environmentObject(repository)
            }

        }
        
        

        
        .sheet(isPresented: $showPremiumUpgrade) {
            PremiumUpgradeView(theme: themeManager.currentTheme)
                .environmentObject(user)
        }
        .onAppear {
            // Start animations
            withAnimation {
                showCircle = true
            }
            
            
            // Simulate timer counting up
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                withAnimation {
                    if currentTime < totalTime {
                        currentTime += totalTime / 60
                    } else {
                        currentTime = totalTime
                        timer.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showDetails = true
                        }
                    }
                }
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02dh:%02dm:%02ds", hours, minutes, seconds)
    }
}
struct RunFinishedView_Preview: PreviewProvider {
    static var previews: some View {
        RunFinishedView(checkpoints: 10, distance: 5200, totalTime: 3661)
            .environmentObject(LoginSave(id: UUID(), token: "Mock_token", status: "Logged in", firstName: "Brajan", lastName: "Kukk", hasPro: true))
            .environmentObject(ThemeManager())
            .environmentObject(
                LocationViewModel(
                    AccessToken: "mock-token"
                )
            )
            .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
    }
}
