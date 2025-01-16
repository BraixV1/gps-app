//
//  SelectActionView.swift
//  map-project
//
//  Created by Brajan Kukk on 29.12.2024.
//
import SwiftUI
import SwiftData

struct SelectActionView: View {
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var repository: LoginDataRepository
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var locationViewModel: LocationViewModel = LocationViewModel(AccessToken: "")
    @State private var navigateToNewSession: Bool = false
    @State private var navigateToReumeSession: Bool = false
    @State private var navigateToThemes: Bool = false
    @State private var showProUpgrade: Bool = false
    @State private var buttonsVisible: Bool = false
    @State private var headerOffset: CGFloat = -50
    @State private var headerOpacity: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Welcome Header
                        VStack(spacing: 8) {
                            Text("Welcome back")
                                .font(.title3)
                                .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                            
                            Text(user.firstName)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.textColor)
                        }
                        .offset(y: headerOffset)
                        .opacity(headerOpacity)
                        .onAppear {
                            withAnimation(.spring(duration: 0.6)) {
                                headerOffset = 0
                                headerOpacity = 1
                            }
                        }
                        
                        // Pro Banner (if not pro)
                        if !user.hasPro {
                            ProPromotionCarousel(theme: themeManager.currentTheme) {
                                showProUpgrade = true
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Main Actions
                        VStack(spacing: 16) {
                            ActionButton(
                                title: "New Session",
                                icon: "play.circle.fill",
                                theme: themeManager.currentTheme,
                                action: { navigateToNewSession = true },
                                isPro: false,
                                isEnabled: true
                            )
                            
                            ActionButton(
                                title: "Previous Sessions",
                                icon: "clock.fill",
                                theme: themeManager.currentTheme,
                                action: { navigateToReumeSession = true },
                                isPro: false,
                                isEnabled: true
                            )
                            
                            ActionButton(
                                title: "Themes",
                                icon: "paintpalette.fill",
                                theme: themeManager.currentTheme,
                                action: {
                                    if user.hasPro {
                                        navigateToThemes = true
                                    } else {
                                        showProUpgrade = true
                                    }
                                },
                                isPro: true,
                                isEnabled: user.hasPro
                            )
                        }
                        .opacity(buttonsVisible ? 1 : 0)
                        .offset(y: buttonsVisible ? 0 : 50)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                }
                VStack {
                    Spacer()
                    BottomNavBar(selectedTab: Tab.home)
                        .environmentObject(user)
                        .environmentObject(repository)
                        .environmentObject(locationViewModel)
                        .environmentObject(themeManager)
                        .padding()
                }
                
                // Hamburger Menu Overlay


            }
            .navigationDestination(isPresented: $navigateToNewSession) {
                NewSessionView()
                    .environmentObject(locationViewModel)
            }
            .navigationDestination(isPresented: $navigateToReumeSession) {
                ResumeTrackView()
                    .environmentObject(locationViewModel)
            }
            .navigationDestination(isPresented: $navigateToThemes) {
                ThemeChangeView()

                    .environmentObject(locationViewModel)
            }
            .sheet(isPresented: $showProUpgrade) {
                PremiumUpgradeView(theme: themeManager.currentTheme)
                    .environmentObject(user)
                    .environmentObject(themeManager)
            }
            .onAppear {
                locationViewModel.stopTracking()
                locationViewModel.resetLocationViewModel()
                locationViewModel.updateToken(accessToken: user.token)
                withAnimation(.easeOut(duration: 0.6)) {
                    buttonsVisible = true
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SelectActionView()
        .environmentObject(LoginSave(token: "sample_token", status: "logged_in", firstName: "Brajan", lastName: "Kukk"))
        .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
        .environmentObject(ThemeManager())
}
