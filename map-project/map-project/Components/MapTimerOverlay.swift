//
//  TImerComponent.swift
//  map-project
//
//  Created by Brajan Kukk on 31.12.2024.
//
import SwiftUI

struct MapTimerOverlay: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isExpanded = false
    @State private var showBottomContent = false
    @State private var containerWidth: CGFloat = 0
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Timer View
            HStack(spacing: 12) {
                if locationViewModel.isPaused {
                    Image(systemName: "pause.circle.fill")
                        .foregroundStyle(themeManager.currentTheme.primaryGradient)
                }
                
                Text(formatElapsedTime(locationViewModel.elapsedTime))
                    .font(.system(.title3, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(themeManager.currentTheme.primaryGradient)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.spring(response: 0.3), value: isExpanded)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
            .overlay {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            containerWidth = geo.size.width
                        }
                }
            }
            .onTapGesture {
                toggleExpansion()
            }
            
            // Expanded Stats View
            if isExpanded {
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        // Speed Display
                        HStack(spacing: 8) {
                            Speedometer(speed: locationViewModel.calculateAverageSpeed(for: locationViewModel.track ))
                                .environmentObject(themeManager)
                            Text("\(String(format: "%.1f", locationViewModel.calculateAverageSpeed(for: locationViewModel.track) ?? 0)) km/h")
                                .foregroundStyle(.white)
                        }
                        
                        // Pace Display
                        Text("\(locationViewModel.calculateAveragePace() ?? "0:00/km")")
                            .foregroundStyle(.white)
                    }
                    
                    // Distance Display
                    Text(String(format: "%.2f km", locationViewModel.calculateTotalDistance() / 1000))
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(width: containerWidth)
                .background {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .animation(.spring(response: 0.3), value: isExpanded)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private func toggleExpansion() {
        withAnimation {
            isExpanded.toggle()
        }
    }
    
    private func formatElapsedTime(_ elapsedTime: TimeInterval) -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// Preview provider
struct MapTimerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.8) // Dark background to simulate map
            MapTimerOverlay()
                .environmentObject(LocationViewModel(AccessToken: "Mock_Token"))
                .environmentObject(ThemeManager())
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

