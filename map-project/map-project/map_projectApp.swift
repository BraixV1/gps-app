//
//  map_projectApp.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//
import SwiftUI
import SwiftData


@main
struct map_projectApp: App {
    @StateObject private var loginRepository: LoginDataRepository
    @StateObject private var user: LoginSave
    @StateObject private var themeManager: ThemeManager = ThemeManager()
    @StateObject private var config: Config = Config()
    @State private var showGreeting = true

    init() {
        // Initialize the ModelContainer
        let container: ModelContainer
        do {
            container = try ModelContainer(for: LoginSave.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        
        // Initialize repositories and user state
        let initialRepository = LoginDataRepository(container: container)
        let initialUser = initialRepository.getAll().first ?? LoginSave(token: "", status: "", firstName: "", lastName: "")
        
        // Assign StateObjects
        _loginRepository = StateObject(wrappedValue: initialRepository)
        _user = StateObject(wrappedValue: initialUser)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if user.token.isEmpty {
                    LoginView()
                        .environmentObject(user)
                        .environmentObject(loginRepository)
                        .environmentObject(themeManager)
                        .onAppear {
                            setupInitialTheme()
                        }
                } else {
                    SelectActionView()
                        .environmentObject(loginRepository)
                        .environmentObject(user)
                        .environmentObject(themeManager)
                        .environmentObject(config)
                        .onAppear {
                            setupInitialTheme()
                        }
                }
            }
            .modelContainer(for: LoginSave.self)
        }
    }
    
    private func setupInitialTheme() {
        if user.token.isEmpty {
            themeManager.currentTheme = themes.first!
        }
        if !user.hasPro && !themeManager.currentTheme.Free {
            themeManager.currentTheme = themes.first!
        }
    }
}
