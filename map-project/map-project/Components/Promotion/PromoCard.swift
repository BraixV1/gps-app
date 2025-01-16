//
//  PromoCard.swift
//  map-project
//
//  Created by Brajan Kukk on 08.01.2025.
//
import SwiftUI


struct PromoCard: View {
    let theme: Theme
    let item: PromoItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(item.iconColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .opacity(0.9)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [theme.primaryColor.opacity(0.3), theme.secondaryColor.opacity(0.1)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(theme.textColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(theme.primaryColor.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}
