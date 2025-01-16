//
//  TrackCard.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI
import Foundation

struct TrackCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let track: GpsSessionResponseGetAll
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    @GestureState private var isDragging = false
    
    var body: some View {
        ZStack {
            // Delete Button
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        offset = 0
                        isSwiped = false
                        onDelete()
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 100)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                }
                .opacity(isSwiped ? 1 : 0)
            }
            
            // Card Content
            VStack(spacing: 12) {
                // Session Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(track.name)
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    
                    if !track.description.isEmpty {
                        Text(track.description)
                            .font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: 16) {
                        StatBadge(icon: "clock.fill", value: "\(track.duration)min")
                        StatBadge(icon: "figure.walk", value: "\(String(format: "%.1f", track.distance))km")
                        StatBadge(icon: "speedometer", value: "\(String(format: "%.1f", track.speed))km/h")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(isSelected ? themeManager.currentTheme.buttonGradientSelected : themeManager.currentTheme.buttonGradient)
                .cornerRadius(12)
                
                // Select Button
                Button(action: onSelect) {
                    Text(isSelected ? "Selected" : "Select Session")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isSelected ? themeManager.currentTheme.buttonGradientSelected : themeManager.currentTheme.buttonGradient)
                        .foregroundColor(themeManager.currentTheme.textColor)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .updating($isDragging) { value, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        if abs(value.translation.height) < abs(value.translation.width) {
                            if value.translation.width < 0 {
                                offset = max(value.translation.width, -60)
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if value.translation.width < -50 && abs(value.translation.height) < 20 {
                                offset = -60
                                isSwiped = true
                            } else {
                                offset = 0
                                isSwiped = false
                            }
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        if isSwiped {
                            withAnimation {
                                offset = 0
                                isSwiped = false
                            }
                        }
                    }
            )
        }
    }
}
