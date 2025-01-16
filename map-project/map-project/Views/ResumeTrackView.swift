//
//  ResumeTrackView.swift
//  map-project
//
//  Created by Brajan Kukk on 28.12.2024.
//

import SwiftUI
import SwiftData
import Foundation

struct ResumeTrackView: View {
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var repository: LoginDataRepository
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var myTracks: [GpsSessionResponseGetAll] = []
    @ObservedObject private var selectedTrack = SelectedTrack()
    @State private var navigateToTracking: Bool = false
    @State private var isLoading: Bool = true
    @State private var errors: [String] = []
    @State private var headerOffset: CGFloat = -50
    @State private var headerOpacity: Double = 0
    
    var body: some View {
            NavigationStack {
                ZStack {
                    themeManager.currentTheme.primaryGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            headerView
                                .padding(.top, 70)
                                .offset(y: headerOffset)
                                .opacity(headerOpacity)
                            
                            if !errors.isEmpty {
                                ErrorsBox(Errors: errors)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            LazyVStack(spacing: 16) {
                                ForEach(myTracks) { track in
                                    trackCard(for: track)
                                        .id(track.id) // Explicit ID for better list management
                                }
                            }
                            .padding(.horizontal)
                            
                            Button {
                                if selectedTrack.id != nil {
                                    Task {
                                        await MainActor.run {
                                            locationViewModel.startTime = selectedTrack.startedAt
                                            locationViewModel.setGpsSessionId(gpsSessionId: selectedTrack.id)
                                        }
                                        navigateToTracking = true
                                    }
                                }
                            } label: {
                                continueButtonLabel()
                            }
                            .disabled(selectedTrack.id == nil)
                            .padding(.horizontal)
                            .padding(.bottom, 100) // Add padding for BottomNavBar
                        }
                    }
                    .scrollIndicators(.hidden)
                    .refreshable {
                        await refreshTracks()
                    }
                    
                    VStack {
                        Spacer()
                        BottomNavBar(selectedTab: Tab.activities)
                            .environmentObject(user)
                            .environmentObject(repository)
                            .environmentObject(locationViewModel)
                    }
                }
                .overlay(
                    Group {
                        if isLoading {
                            SpinnerOverlay()
                        }
                    }
                )
                .navigationDestination(isPresented: $navigateToTracking) {
                    MainView()
                        .environmentObject(locationViewModel)
                        .environmentObject(repository)
                        .environmentObject(user)
                }
                .onAppear {
                    Task {
                        locationViewModel.stopTracking()
                        locationViewModel.resetLocationViewModel()
                        await setupTracks()
                    }
                    withAnimation(.easeOut(duration: 0.6)) {
                        headerOffset = 0
                        headerOpacity = 1
                    }
                }
            }
        }
    
    private func trackCard(for track: GpsSessionResponseGetAll) -> some View {
        TrackCard(
            track: track,
            isSelected: selectedTrack.id == track.id,
            onSelect: {
                withAnimation(.spring(response: 0.3)) {
                    selectedTrack.id = track.id
                    selectedTrack.startedAt = track.recordedAt
                }
            },
            onDelete: {
                Task {
                    await deleteTrack(track: track)
                }
            }
        )
        .environmentObject(themeManager)
    }

    
    private func continueButtonLabel() -> some View {
        HStack {
            Image(systemName: "play.fill")
            Text("Continue Session")
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(selectedTrack.id != nil ? themeManager.currentTheme.buttonGradientSelected : themeManager.currentTheme.buttonGradient)
        .foregroundColor(themeManager.currentTheme.textColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
    }

    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Previous Sessions")
                .font(.title2.bold())
                .foregroundColor(themeManager.currentTheme.textColor)
            Text("Continue from where you left off")
                .font(.subheadline)
                .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
        }
        .padding(.top, 70)
        .offset(y: headerOffset)
        .opacity(headerOpacity)
    }

    
    
    
    private func buttonColor() -> Color {
        if selectedTrack.id == nil {
            return Color.gray
        } else {
            return Color.green
        }
    }
    
    private func refreshTracks() async {
        await setupTracks()
    }
    
    private func deleteTrack(track: GpsSessionResponseGetAll) async {
        let service = GpsSessionService<GpsSessionDelete, GpsSessionDelete>(baseUrl: "/GpsSessions", accessToken: user.token)
        let result = await service.delete(id: track.id.uuidString)
        if let unwrappedErrors = result.errors {
            errors = unwrappedErrors
        } else {
            myTracks.removeAll { $0.id == track.id }
        }
    }

    
    private func setupTracks() async {
        isLoading = true
        myTracks = []
        let service = GpsSessionService<GpsSessionResponseGetAll, GpsSessionResponseGetAll>(baseUrl: "/GpsSessions")
        let queryParams = [
            "minLocationsCount": "0",
            "minDuration": "0",
            "minDistance": "0"
        ]
        let result = await service.getAll(queryParams: queryParams)
        
        if let unwrappedTracks = result.data {
            myTracks = unwrappedTracks.filter( { $0.userFirstLastName == "\(user.firstName) \(user.lastName)"})
        }
        if let unwrappedErrors = result.errors {
            errors = unwrappedErrors
        }
        isLoading = false
    }

}

#Preview {
    ResumeTrackView()
        .environmentObject(LoginSave(token: "Mock_token", status: "Mock_status", firstName: "Brajan", lastName: "Kukk"))
        .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
        .environmentObject(LocationViewModel(AccessToken: "Mock token"))
        .environmentObject(ThemeManager())
}
