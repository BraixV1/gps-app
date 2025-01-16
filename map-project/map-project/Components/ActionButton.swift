//
//  ActionButton.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ActionButton: View {
    let title: String
    let icon: String
    let theme: Theme
    let action: () -> Void
    var isPro: Bool = false
    var isEnabled: Bool = true
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.2)) {
                scale = 0.95
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                scale = 1.0
                action()
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                if isPro && !isEnabled {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                theme.buttonGradient
                    .opacity(isEnabled ? 1 : 0.7)
            )
            .foregroundColor(theme.textColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
        }
        .scaleEffect(scale)
        .disabled(!isEnabled)
    }
}
