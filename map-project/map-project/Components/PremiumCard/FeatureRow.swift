//
//  FeatureRow.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 32)
            
            Text(text)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
