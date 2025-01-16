//
//  PlanCard.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//

import SwiftUI

struct PlanCard: View {
    let isSelected: Bool
    let title: String
    let price: String
    let billingPeriod: String
    var savings: String? = nil
    let theme: Theme
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("€")
                            .font(.title3)
                        Text(price)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(billingPeriod)
                            .font(.subheadline)
                    }
                    
                    if let savings = savings {
                        Text(savings)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(theme.textColor.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
            }
            .padding()
            .foregroundColor(theme.textColor)
            .background(isSelected ? theme.buttonGradient : theme.buttonGradientSelected)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? theme.textColor : theme.textColor.opacity(0.2), lineWidth: 2)
            )
        }
    }
}
