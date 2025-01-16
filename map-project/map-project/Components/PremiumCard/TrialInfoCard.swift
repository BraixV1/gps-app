//
//  TrialInfoCard.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//

import SwiftUI

struct TrialInfoCard: View {
    let theme: Theme
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "gift.fill")
                    .font(.title2)
                Text("What's Included in Your Free Trial")
                    .font(.headline)
            }
            .foregroundColor(theme.textColor)
            
            Text("Full access to all premium features, themes, and advanced tracking capabilities for 7 days. No commitment required.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(theme.textColor.opacity(0.9))
        }
        .padding()
        .background(theme.buttonGradient.opacity(0.3))
        .cornerRadius(12)
    }
}
