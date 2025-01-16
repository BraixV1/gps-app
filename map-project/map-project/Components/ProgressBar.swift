//
//  ProgressBar.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.white.opacity(0.3))
                
                Rectangle()
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(.white)
            }
        }
        .cornerRadius(2)
    }
}
