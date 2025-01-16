//
//  Dropdown.swift
//  map-project
//
//  Created by Brajan Kukk on 27.12.2024.
//
import SwiftUI
import SwiftData

struct BottomNavBar: View {
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var loginRepository: LoginDataRepository
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    
    @State var showWarning = false
    
    @State var selectedTab = Tab.home
    
    
    @State private var showProfileSheet = false
    @State private var showHome = false
    @State private var showSessions = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    ForEach([Tab.home, Tab.activities, Tab.profile, Tab.settings], id: \.self) { tab in
                        tabItem(tab)
                        
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: -5)
                        .blur(radius: 1)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .sheet(isPresented: $showProfileSheet) {
                ProfileView(isPresented: $showProfileSheet)
                    .environmentObject(locationViewModel)
            }
            .navigationDestination(isPresented: $showHome) {
                SelectActionView()
                    .environmentObject(loginRepository)
                    .environmentObject(user)
                    .environmentObject(themeManager)
                    .environmentObject(locationViewModel)
                
            }
            .navigationDestination(isPresented: $showSessions) {
                ResumeTrackView()
                    .environmentObject(loginRepository)
                    .environmentObject(user)
                    .environmentObject(themeManager)
                    .environmentObject(locationViewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleTabSelection(_ tab: Tab) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedTab = tab
            
            switch tab {
            case .profile:
                showProfileSheet = true
            case .home:
                if showWarning {
                    
                }
                else {
                    showHome = true
                }
                
            case .activities:
                if showWarning {
                    
                } else {
                    showSessions = true
                }
            default:
                break
            }
        }
    }
    

    private func tabItem(_ tabName: Tab) -> some View {
        Button(action: {
            handleTabSelection(tabName)
        }) {
            VStack(spacing: 4) {
                Image(systemName: tabName.icon)
                    .symbolEffect(.bounce, value: selectedTab == tabName)
                    .font(.system(size: 24))
                Text(tabName.title)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundColor(selectedTab == tabName ?
                             themeManager.currentTheme.primaryColor : // Ensure `primaryColor` is a Color
                             Color.gray)
        }
    }

}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
            .environmentObject(LoginSave(token: "sample_token", status: "logged_in", firstName: "John", lastName: "Doe"))
            .environmentObject(LocationViewModel(AccessToken: "mock_token"))
            .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
            .environmentObject(ThemeManager())
    }
}
