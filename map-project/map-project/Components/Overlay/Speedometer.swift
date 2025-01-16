//
//  Spedometer.swift
//  map-project
//
//  Created by Brajan Kukk on 03.01.2025.
//

import SwiftUI

struct Speedometer: View {
    @EnvironmentObject var themeManager: ThemeManager
    let speed: Double?
    
    var body: some View {
        Group {
            if let speed = speed {
                if speed > 2.2 {
                    SpeedometerIcon("figure.run")
                } else if speed > 1.4 {
                    SpeedometerIcon("figure.walk")
                } else {
                    SpeedometerIcon("figure.stand")
                }
            } else {
                SpeedometerIcon("figure.stand")
            }
        }
    }
    
    @ViewBuilder
    private func SpeedometerIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .imageScale(.large)
            .foregroundStyle(themeManager.currentTheme.primaryGradient)
    }
}
