//
//  UniversalDropdown.swift
//  map-project
//
//  Created by Brajan Kukk on 27.12.2024.
//

import SwiftUI

struct UniversalDropdown<T: Hashable>: View {
    let labels: [String]
    let values: [T]
    @Binding var selectedValue: T?

    var placeholder: String

    var body: some View {
        Menu {
            ForEach(Array(labels.enumerated()), id: \.1) { index, label in
                Button(action: {
                    selectedValue = values[index]
                }) {
                    HStack {
                        Text(label)
                        if selectedValue == values[index] {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        } label: {
            Text(selectedValue.map { labels[values.firstIndex(of: $0)!] } ?? placeholder)
                .foregroundColor(selectedValue == nil ? .gray : .primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}
