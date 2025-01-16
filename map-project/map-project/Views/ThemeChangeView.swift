//
//  ThemeChangeView.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ThemeChangeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var repository: LoginDataRepository
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var user: LoginSave
    @Environment(\.dismiss) var dismiss
    @State private var selectedTheme: Theme?
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.primaryGradient
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(themes) { theme in
                            ThemePreviewCard(theme: theme, isSelected: themeManager.currentTheme.id == theme.id)

                        }
                    }
                    .padding()
                }
                .navigationTitle("Theme Selection")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                VStack {
                    Spacer()
                    BottomNavBar()
                        .environmentObject(locationViewModel)
                }
            }
        }
    }
}
// Preview provider
#Preview {
    ThemeChangeView()
        .environmentObject(ThemeManager())
}
