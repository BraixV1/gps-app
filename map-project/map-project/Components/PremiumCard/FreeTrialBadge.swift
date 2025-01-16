//
//  Untitled.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//

import SwiftUI


struct FreeTrialBadge: View {
    let theme: Theme
    
    var body: some View {
        Text("7 DAYS FREE")
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(theme.buttonGradient)
            .foregroundColor(theme.textColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.textColor, lineWidth: 1)
            )
    }
}
