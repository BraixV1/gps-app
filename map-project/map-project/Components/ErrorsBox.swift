//
//  ErrorsBox.swift
//  map-project
//
//  Created by Brajan Kukk on 29.12.2024.
//

import SwiftUI

struct ErrorsBox: View {
    
    var Errors: [String]
    
    var body: some View {
        if !Errors.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Errors, id: \.self) { error in
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
        }
    }
    
}
