//
//  TrackingView.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//

import SwiftUI
import SwiftData
import ActivityKit
import WidgetKit
import UniformTypeIdentifiers

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var repository: LoginDataRepository
    @EnvironmentObject var themeManager: ThemeManager
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isPortrait: Bool {
        horizontalSizeClass == .compact
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(track: locationViewModel.track,
                       checkpoints: locationViewModel.checkpoints,
                       waypoint: locationViewModel.waypoint,
                       colored: locationViewModel.colored,
                       config: locationViewModel.config)
                
                MapTimerOverlay()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding()
                if isPortrait {
                    TrackingControlKit()
                        .padding(.bottom, 80)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .environmentObject(locationViewModel)
                } else {
                    HStack {
                        TrackingControlKit()
                            .padding(.bottom, 80)
                            .rotationEffect(.degrees(-90))
                            .environmentObject(locationViewModel)
                        Spacer()
                    }
                }

                BottomNavBar()
                    .environmentObject(locationViewModel)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .navigationBarBackButtonHidden(locationViewModel.isTracking)
        }
        .navigationDestination(isPresented: $locationViewModel.isStopped) {
            RunFinishedView(
                checkpoints: locationViewModel.checkpoints.count,
                distance: locationViewModel.distance,
                totalTime: locationViewModel.elapsedTime
            )
            .environmentObject(locationViewModel)
        }
    }
}

#Preview {
    TrackingView()
        .environmentObject(
            LocationViewModel(
                AccessToken: "mock-token"
            )
        )
        .environmentObject(LoginSave(id: UUID(), token: "Mock_token", status: "Logged in", firstName: "Brajan", lastName: "Kukk"))
        .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
        .environmentObject(ThemeManager())
    
}
