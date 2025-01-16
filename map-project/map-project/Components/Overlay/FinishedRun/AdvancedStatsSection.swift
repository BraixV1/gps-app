//
//  AdvancedStatsSection.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//

import SwiftUI


struct AdvancedStatsSection: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var user: LoginSave
    
    @State private var gpxFileURL: URL?
    @State private var showFileExporter = false
    @State private var navigateToAdvancedStats = false

    
    let theme: Theme
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Advanced Statistics")
                    .font(.title3.bold())
                    .foregroundColor(theme.textColor)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    // Checkpoint Stats
                    StatsCard(
                        title: "Checkpoint Pace",
                        value: locationViewModel.calculateCheckpointPace() ?? "N/A",
                        theme: theme
                    )
                    
                    StatsCard(
                        title: "Waypoint Pace",
                        value: locationViewModel.calculateWaypointPace() ?? "N/A",
                        theme: theme
                    )
                    
                    // Split times between checkpoints
                    if locationViewModel.checkpoints.count > 1 {
                        let checkpoints = locationViewModel.checkpoints
                        let lastTwo = Array(checkpoints.suffix(2))
                        let splitTime = lastTwo[1].location.timestamp.timeIntervalSince(lastTwo[0].location.timestamp)
                        StatsCard(
                            title: "Last Split Time",
                            value: formatTime(splitTime),
                            theme: theme
                        )
                    }
                    
                    // Average speed
                    if let avgSpeed = locationViewModel.averageSpeed {
                        StatsCard(
                            title: "Average Speed",
                            value: String(format: "%.2f km/h", avgSpeed * 3.6),
                            theme: theme
                        )
                    }
                }
                
                // Additional advanced metrics
                VStack(spacing: 12) {
                    if let waypointSpeed = locationViewModel.calculateWaypointSpeed() {
                        Text("Waypoint Speed: \(String(format: "%.2f km/h", waypointSpeed * 3.6))")
                            .foregroundColor(theme.textColor)
                    }
                    
                    if let checkpointSpeed = locationViewModel.calculateCheckpointSpeed() {
                        Text("Checkpoint Speed: \(String(format: "%.2f km/h", checkpointSpeed * 3.6))")
                            .foregroundColor(theme.textColor)
                    }
                }
                .font(.subheadline)
                
                // Export button
                Button(action: {
                    navigateToAdvancedStats = true
                }) {
                    HStack {
                        // Image(systemName: "square.and.arrow.up")
                        Text("Advanced stats")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.buttonGradientSelected)
                    .foregroundColor(theme.textColor)
                    .cornerRadius(12)
                    }
                }
                .padding()
                .background(theme.buttonGradient.opacity(0.2))
                .cornerRadius(16)
                
                // Export button
            Button(action: {
                exportGPXFile()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export GPX")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .disabled(user.hasPro)
                .background(theme.buttonGradientSelected)
                .foregroundColor(theme.textColor)
                .cornerRadius(12)
            }
            .padding()
            .background(theme.buttonGradient.opacity(0.2))
            .cornerRadius(16)
            .fileExporter(
                isPresented: $showFileExporter,
                document: GPXDocument(fileURL: gpxFileURL),
                contentType: .xml,
                defaultFilename: "track_and_checkpoints"
            ) { result in
                switch result {
                case .success(let url):
                    print("File exported successfully to \(url)")
                case .failure(let error):
                    print("Failed to export file: \(error)")
                }
            }
        }
        .navigationDestination(isPresented: $navigateToAdvancedStats) {
            AdditionalPremiumStats(theme: theme)
                .environmentObject(locationViewModel)
        }
    }
    
    private func exportGPXFile() {
        if let fileURL = locationViewModel.exportToGPX() {
            gpxFileURL = fileURL
            showFileExporter = true
        } else {
            print("Failed to create GPX file")
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02dh:%02dm:%02ds", hours, minutes, seconds)
    }
}
