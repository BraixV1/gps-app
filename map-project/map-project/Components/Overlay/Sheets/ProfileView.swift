//
//  ProfileView.swift
//  map-project
//
//  Created by Brajan Kukk on 07.01.2025.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var loginRepository: LoginDataRepository
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(themeManager.currentTheme.primaryGradient)
                        VStack(alignment: .leading) {
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.title3)
                                .bold()
                            Text("Active Runner")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Account") {
                    NavigationLink {
                        Text("Edit Profile")
                    } label: {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                    
                    NavigationLink {
                        Text("Statistics")
                    } label: {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }
                    
                    if locationViewModel.gpsSessionId != nil {
                        Button {
                            locationViewModel.startLiveActivity()
                        } label: {
                            Label("Start Live Activity", systemImage: "paperplane.circle.fill")
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        logout()
                    } label: {
                        Label("Log Out", systemImage: "arrow.right.circle")
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func logout() {
        loginRepository.delete(login: user)
        user.token = ""
        user.status = ""
        user.firstName = ""
        user.lastName = ""
        user.hasPro = false
        isPresented = false
    }
}
