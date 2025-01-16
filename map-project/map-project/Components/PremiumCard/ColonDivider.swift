//
//  ColonDivider.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI


struct ColonDivider: View {
    let theme: Theme
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Text(":")
            .font(.title.bold())
            .foregroundColor(theme.textColor)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
                    opacity = 0.3
                }
            }
    }
}
