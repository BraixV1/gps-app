//
//  AdditionalPremiumStats.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//
import SwiftUI

struct AdditionalPremiumStats: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let theme: Theme

    @State private var caloriesBurned: Double = 0
    @State private var stepsTaken: Int = 0
    @State private var highestSpeed: Double? = nil
    @State private var elevationStats: (gain: Double, loss: Double) = (0, 0)
    @State private var kilometerSplits: [(kilometer: Int, pace: String)] = []
    @State private var intensityZones: [String: TimeInterval] = [:]

    var body: some View {
        ZStack {
            theme.primaryGradient
            VStack(spacing: 24) {
                Text("Detailed Analysis")
                    .font(.title3.bold())
                    .foregroundColor(theme.textColor)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatsCard(
                            title: "Calories Burned",
                            value: String(format: "%.0f kcal", caloriesBurned),
                            theme: theme
                        )
                        StatsCard(
                            title: "Step counter",
                            value: "\(stepsTaken) steps",
                            theme: theme
                        )
                    }

                    if let speed = highestSpeed {
                        StatsCard(
                            title: "Top Speed",
                            value: String(format: "%.1f km/h", speed * 3.6),
                            theme: theme
                        )
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatsCard(
                            title: "Elevation Gain",
                            value: String(format: "%.0f m", elevationStats.gain),
                            theme: theme
                        )
                        StatsCard(
                            title: "Elevation Loss",
                            value: String(format: "%.0f m", elevationStats.loss),
                            theme: theme
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Kilometer Splits")
                            .font(.headline)
                            .foregroundColor(theme.textColor)
                        ForEach(kilometerSplits, id: \.kilometer) { split in
                            HStack {
                                Text("Km \(split.kilometer)")
                                    .foregroundColor(theme.textColor.opacity(0.8))
                                Spacer()
                                Text(split.pace)
                                    .foregroundColor(theme.textColor)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(theme.buttonGradient.opacity(0.3))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Intensity Zones")
                            .font(.headline)
                            .foregroundColor(theme.textColor)
                        ForEach(Array(intensityZones.keys.sorted()), id: \.self) { zone in
                            if let duration = intensityZones[zone], duration > 0 {
                                HStack {
                                    Text(zone)
                                        .foregroundColor(theme.textColor.opacity(0.8))
                                    Spacer()
                                    Text(formatTime(duration))
                                        .foregroundColor(theme.textColor)
                                }
                                .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .background(theme.buttonGradient.opacity(0.3))
                    .cornerRadius(12)
                }
                .padding()
                .background(theme.buttonGradient.opacity(0.2))
                .cornerRadius(16)
            }
        }
        .onAppear {
            loadStats()
        }
    }

    private func loadStats() {
        // Precompute and store data for the view
        caloriesBurned = locationViewModel.calculateCaloriesBurned()
        stepsTaken = locationViewModel.calculateSteps()
        highestSpeed = locationViewModel.calculateHighestSpeed()
        elevationStats = locationViewModel.calculateElevationStats()
        kilometerSplits = locationViewModel.calculateKilometerSplits()
        intensityZones = locationViewModel.calculateIntensityZones()
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
