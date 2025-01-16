//
//  TrackLoad.swift
//  map-project
//
//  Created by Brajan Kukk on 29.12.2024.
//
import SwiftUI
import Foundation

struct TrackLoad: View {
    @EnvironmentObject var selectedTrack: SelectedTrack
    @EnvironmentObject var themeManager: ThemeManager
    let gpsSession: GpsSessionResponseGetAll
    @State private var isAnimatingGradient: Bool = false

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name: \(gpsSession.name)")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    
                    Text("Description: \(gpsSession.description)")
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                        .lineLimit(2)
                    
                    Text("Duration: \(gpsSession.duration) min")
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(animatedGradient())
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.8)) {
                    selectedTrack.id = gpsSession.id
                }
            }) {
                Text(selectedTrack.id == gpsSession.id ? "Track Selected" : "Select Track")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedButtonGradient())
                    .cornerRadius(10)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
        .padding()
        .background(
            Color.white
                .opacity(0.6)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }

    private func animatedGradient() -> LinearGradient {
        if selectedTrack.id == gpsSession.id {
            return themeManager.currentTheme.buttonGradientSelected
        } else {
            return themeManager.currentTheme.buttonGradient
        }
    }

    private func selectedButtonGradient() -> LinearGradient {
        if selectedTrack.id == gpsSession.id {
            return themeManager.currentTheme.buttonGradientSelected
        } else {
            return themeManager.currentTheme.buttonGradient
        }
    }
}



#Preview {
    TrackLoad(
        gpsSession: GpsSessionResponseGetAll(
            id: UUID(),
            name: "Morning Run",
            description: "",
            recordedAt: Date(),
            duration: 30,
            speed: 5.2,
            distance: 4.3,
            climb: 50,
            descent: 40,
            paceMin: 6,
            paceMax: 12,
            gpsSessionType: "Running",
            gpsLocationsCount: 150,
            userFirstLastName: "John Doe"
        )
    )
    .environmentObject(SelectedTrack())
    .environmentObject(ThemeManager())
}
