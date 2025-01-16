//
//  PremiumOverlay.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//
import SwiftUI

struct PremiumOverlay: View {
    let theme: Theme
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(theme.primaryColor)
            
            Text("Unlock Advanced Statistics")
                .font(.title3.bold())
                .foregroundColor(theme.textColor)
            
            Text("Get detailed insights into your performance with Pro version")
                .multilineTextAlignment(.center)
                .foregroundColor(theme.textColor.opacity(0.8))
            
            Button(action: action) {
                Text("Upgrade to Pro")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.buttonGradientSelected)
                    .foregroundColor(theme.textColor)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(theme.primaryGradient)
        .cornerRadius(16)
    }
}
