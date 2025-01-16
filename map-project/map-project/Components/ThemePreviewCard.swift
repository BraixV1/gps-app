//
//  ThemePreviewCard.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ThemePreviewCard: View {
    let theme: Theme
    let isSelected: Bool
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var user: LoginSave
    
    @State private var showingPremiumUpgrade = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Header with theme name and lock status
            HStack {
                Text(theme.title)
                    .font(.headline)
                    .foregroundColor(theme.textColor)
                
                Spacer()
                
                if !theme.Free && !user.hasPro {
                    Image(systemName: "lock.fill")
                        .foregroundColor(theme.textColor)
                }
                if !theme.Free && user.hasPro {
                    Image(systemName: "lock.open.fill")
                        .foregroundColor(theme.textColor)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.textColor)
                }
            }
            
            // Theme preview
            VStack(spacing: 8) {
                // Color preview bars
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.walkingColor)
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.joggingColor)
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.runningColor)
                        .frame(height: 20)
                }
                
                // Button preview
                Button(action: {}) {
                    Text("Button Preview")
                        .foregroundColor(theme.textColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(theme.buttonGradient)
                        .cornerRadius(8)
                }
                
                Text(theme.description)
                    .font(.caption)
                    .foregroundColor(theme.textColor)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(theme.primaryGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? theme.textColor : Color.clear, lineWidth: 2)
        )
        .shadow(radius: 5)
        .opacity(theme.Free ? 1 : 0.7)
        .onTapGesture {
            if theme.Free || user.hasPro {
                withAnimation {
                    themeManager.setTheme(theme)
                }
            } else {
                showingPremiumUpgrade = true
            }
        }
        .sheet(isPresented: $showingPremiumUpgrade) {
            PremiumUpgradeView(theme: theme)
                .environmentObject(user)
        }
    }
}
