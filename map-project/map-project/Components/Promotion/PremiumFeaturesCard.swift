//
//  PremiumFeaturesCard.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//

import SwiftUI

struct PremiumFeaturesCard: View {
    let action: () -> Void
    let theme: Theme
    
    var body: some View {
        VStack(spacing: 16) {
            Text("You have exceeded reached the limit of free sessions")
            Text("Premium Features")
                .font(.title3.bold())
                .foregroundColor(theme.textColor)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(PremiumFeatures.features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(feature)
                            .foregroundColor(theme.textColor)
                    }
                }
            }
            
            Button(action: action) {
                Text("Upgrade to Premium")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.buttonGradientSelected)
                    .foregroundColor(theme.textColor)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(theme.buttonGradient.opacity(0.3))
        .cornerRadius(16)
    }
}
