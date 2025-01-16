//
//  NewSessionCreation.swift
//  map-project
//
//  Created by Brajan Kukk on 27.12.2024.
//
import SwiftUI
import Foundation
import SwiftData


struct NewSessionView: View {
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var repository: LoginDataRepository
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var gpsSession = GpsSession(
        name: "",
        description: "",
        gpsSessionTypeId: nil,
        recordedAt: Date(),
        paceMin: 0,
        paceMax: 0
    )
    @State private var startTracking = false
    @State private var errors: [String] = []
    @State private var gpsSessionTypes: [GpsSessionType] = []
    @State private var selectedSessionType: GpsSessionType? = nil
    @State private var showPremiumUpgrade = false
    @State private var existingSessions = 0
    @State private var isLoading = true
    @State private var headerOffset: CGFloat = -50
    @State private var headerOpacity: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.primaryGradient
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection
                            
                            if !errors.isEmpty {
                                ErrorsBox(Errors: errors)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            SessionFormSection(
                                gpsSession: $gpsSession,
                                selectedSessionType: $selectedSessionType,
                                gpsSessionTypes: gpsSessionTypes,
                                theme: themeManager.currentTheme
                            )
                            
                            if !user.hasPro {
                                if existingSessions >= PremiumFeatures.sessionLimit {
                                    PremiumFeaturesCard(
                                        action: { showPremiumUpgrade = true },
                                        theme: themeManager.currentTheme
                                    )
                                    .padding(.horizontal)
                                } else {
                                    SessionLimitIndicator(
                                        current: existingSessions,
                                        limit: PremiumFeatures.sessionLimit
                                    )
                                }
                            }
                            
                            startButton
                        }
                        .padding()
                    }
                    BottomNavBar()
                        .environmentObject(user)
                        .environmentObject(repository)
                        .environmentObject(locationViewModel)

                }

                
                if isLoading {
                    SpinnerOverlay()
                }
            }
            .navigationDestination(isPresented: $startTracking) {
                MainView()
                    .environmentObject(locationViewModel)
                    .environmentObject(repository)
                    .environmentObject(user)
            }
            .sheet(isPresented: $showPremiumUpgrade) {
                PremiumUpgradeView(theme: themeManager.currentTheme)
                    .environmentObject(user)
                    .environmentObject(themeManager)
            }
            .onAppear {
                Task {
                    await setupData()
                    withAnimation(.easeOut(duration: 0.6)) {
                        headerOffset = 0
                        headerOpacity = 1
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("New Tracking Session")
                .font(.title2.bold())
                .foregroundColor(themeManager.currentTheme.textColor)
        }
        .padding(.top, 70)
        .offset(y: headerOffset)
        .opacity(headerOpacity)
    }
    
    private var startButton: some View {
        Button {
            Task {
                await startGpsSession()
            }
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                Text("Start Session")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                canStartNewSession
                ? themeManager.currentTheme.buttonGradientSelected.opacity(1)
                    : themeManager.currentTheme.buttonGradient.opacity(0.5)
            )
            .foregroundColor(themeManager.currentTheme.textColor)
            .cornerRadius(12)
        }
        .disabled(!canStartNewSession)
        .padding(.horizontal)
    }
    

    
    // MARK: - Helper Properties
    private var canStartNewSession: Bool {
        if user.hasPro { return true }
        return existingSessions < PremiumFeatures.sessionLimit
    }
    
    // MARK: - Functions
    private func setupData() async {
        isLoading = true
        await setupTypes()
        await countExistingSessions()
        locationViewModel.stopTracking()
        locationViewModel.resetLocationViewModel()
        isLoading = false
    }
    
    private func countExistingSessions() async {
        let service = GpsSessionService<GpsSessionResponseGetAll, GpsSessionResponseGetAll>(baseUrl: "/GpsSessions")
        let queryParams = [
            "minLocationsCount": "0",
            "minDuration": "0",
            "minDistance": "0"
        ]
        let result = await service.getAll(queryParams: queryParams)
        
        if let sessions = result.data {
            existingSessions = sessions.filter {
                $0.userFirstLastName == "\(user.firstName) \(user.lastName)"
            }.count
        }
    }
    
    private func setupTypes() async {
        let result = await GpsSessionTypesService<GpsSessionType, GpsSessionType>(baseUrl: "/GpsSessionTypes").getAll()
        
        if let errorMessages = result.errors {
            errors = errorMessages
            return
        }
        
        if let data = result.data {
            gpsSessionTypes = data
            
            if !gpsSessionTypes.isEmpty {
                selectedSessionType = gpsSessionTypes[0]
            }
        } else {
            errors.append("Failed to fetch GPS session types.")
        }
    }
    
    private func startGpsSession() async {
        if !verifiySessionData() {
            return
        }
        
        let result = await GpsSessionService<GpsSession, GpsSessionResponse>(baseUrl: "/GpsSessions", accessToken: user.token).create(data: gpsSession)
        
        if let unwrappedSession = result.data {
            startTracking = true
            locationViewModel.setGpsSessionId(gpsSessionId: unwrappedSession.id)
        }
        if let unwrappedErrors = result.errors {
            errors = unwrappedErrors
        }
    }
    
    private func verifiySessionData() -> Bool {
        errors.removeAll()
        
        if let unwrappedType = selectedSessionType {
            gpsSession.paceMax = unwrappedType.paceMax
            gpsSession.paceMin = unwrappedType.paceMin
            gpsSession.gpsSessionTypeId = unwrappedType.id
        } else {
            errors.append("Session type has not been selected.")
            return false
        }
        
        if gpsSession.name.isEmpty {
            errors.append("Session name can't be empty.")
            return false
        }
        
        if gpsSession.description.isEmpty {
            errors.append("Session description can't be empty.")
            return false
        }
        
        if gpsSession.paceMax <= gpsSession.paceMin {
            errors.append("Max pace must be greater than min pace.")
            return false
        }
        
        // Add premium feature limitations
        if !user.hasPro {
            if existingSessions >= PremiumFeatures.sessionLimit {
                errors.append("You've reached the free plan session limit.")
                return false
            }
        }
        
        return true
    }
}

#Preview {
    NewSessionView()
        .environmentObject(LoginSave(token: "mock_token", status: "logged_in", firstName: "Brajan", lastName: "Kukk"))
        .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
        .environmentObject(LocationViewModel(AccessToken: "Mock token"))
        .environmentObject(ThemeManager())
}

