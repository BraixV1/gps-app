//
//  LabeledTextField.swift
//  map-project
//
//  Created by Brajan Kukk on 02.01.2025.
//

import SwiftUI

struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(10)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
        }
    }
}
