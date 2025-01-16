//
//  StatBadge.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI


struct StatBadge: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(value)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(themeManager.currentTheme.secondaryColor.opacity(0.2))
        .cornerRadius(8)
        .foregroundColor(themeManager.currentTheme.textColor)
    }
}
