//
//  FormField.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isMultiline: Bool = false
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.textColor)
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(themeManager.currentTheme.textColor)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(themeManager.currentTheme.textColor)
            }
        }
    }
}
