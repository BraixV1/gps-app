//
//  StatsCard.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//
import SwiftUI

struct StatsCard: View {
    let title: String
    let value: String
    let theme: Theme
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(theme.textColor.opacity(0.8))
            
            Text(value)
                .font(.title3.bold())
                .foregroundColor(theme.textColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(theme.buttonGradient.opacity(0.3))
        .cornerRadius(12)
    }
}
