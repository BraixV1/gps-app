//
//  ProPromotionCard.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//

import SwiftUI

struct ProPromotionCard: View {
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    Text("Upgrade to Pro")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Text("Get unlimited sessions and more premium features!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.3))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
