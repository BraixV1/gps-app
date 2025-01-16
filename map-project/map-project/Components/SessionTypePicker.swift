//
//  SessionTypePicker.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//
import SwiftUI

struct SessionTypePicker: View {
    @Binding var selectedType: GpsSessionType?
    let types: [GpsSessionType]
    let theme: Theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Activity Type")
                .font(.headline)
                .foregroundColor(theme.textColor)
            
            Menu {
                ForEach(types) { type in
                    Button(action: { selectedType = type }) {
                        HStack {
                            Text(type.name)
                            if selectedType?.id == type.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedType?.name ?? "Select type")
                        .foregroundColor(theme.textColor)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(theme.textColor)
                }
                .padding()
                .background(theme.buttonGradient)
                .cornerRadius(12)
            }
        }
    }
}

struct SessionFormSection: View {
    @Binding var gpsSession: GpsSession
    @Binding var selectedSessionType: GpsSessionType?
    let gpsSessionTypes: [GpsSessionType]
    let theme: Theme
    
    var body: some View {
        VStack(spacing: 20) {
            FormField(
                title: "Session Name",
                placeholder: "Enter session name",
                text: $gpsSession.name
            )
            
            FormField(
                title: "Description",
                placeholder: "Enter session description",
                text: $gpsSession.description,
                isMultiline: true
            )
            
            SessionTypePicker(
                selectedType: $selectedSessionType,
                types: gpsSessionTypes,
                theme: theme
            )
        }
        .padding(.horizontal)
    }
}
