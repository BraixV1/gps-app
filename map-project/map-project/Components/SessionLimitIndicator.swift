//
//  SessionLimitIndicator.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//

import SwiftUI

struct SessionLimitIndicator: View {
    let current: Int
    let limit: Int
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text("\(current)/\(limit)")
                    .font(.headline)
                Text("Sessions Used")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            
            ProgressBar(progress: Double(current) / Double(limit))
                .frame(width: 200, height: 4)
        }
    }
}
