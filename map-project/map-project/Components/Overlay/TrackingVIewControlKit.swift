//
//  TrackingVIewControlKit.swift
//  map-project
//
//  Created by Brajan Kukk on 29.12.2024.
//

import Foundation
import SwiftUI

struct TrackingControlKit: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isRotating = false
    @State private var isTransitioning = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Play/Pause Button
            mainControlButton
            
            if locationViewModel.isTracking {
                // Stop Button
                controlButton(
                    icon: "stop.circle.fill",
                    gradient: Gradient(colors: [.red, .red.opacity(0.8)]),
                    action: locationViewModel.stopRun
                )
            }
            
            // Waypoint Button
            controlButton(
                icon: "mappin.circle.fill",
                gradient: Gradient(colors: [.green, .yellow]),
                action: locationViewModel.addWaypoint
            )
            
            // Checkpoint Button
            controlButton(
                icon: "mappin.and.ellipse.circle.fill",
                gradient: Gradient(colors: [.pink, .purple]),
                action: locationViewModel.addCheckPoint
            )
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
        }
    }
    
    private var mainControlButton: some View {
        Button(action: handleMainButtonTap) {
            Image(systemName: locationViewModel.isTracking ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(
                    locationViewModel.isTracking ?
                    themeManager.currentTheme.primaryGradient :
                    LinearGradient(colors: [.blue, .purple],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)
                )
        }
        .rotationEffect(.degrees(isRotating ? 360 : 0))
        .opacity(isTransitioning ? 0 : 1)
        .animation(.interpolatingSpring(duration: 0.6), value: isRotating)
    }
    
    private func controlButton(
        icon: String,
        gradient: Gradient,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    private func handleMainButtonTap() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isTransitioning = true
            isRotating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if locationViewModel.isTracking {
                locationViewModel.stopTracking()
                locationViewModel.pauseRun()
            } else {
                locationViewModel.startRun()
                locationViewModel.startTracking()
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                isTransitioning = false
                isRotating = false
            }
        }
    }
}

#Preview {
    TrackingControlKit()
        .environmentObject(LocationViewModel(AccessToken: "mock_token"))
}
