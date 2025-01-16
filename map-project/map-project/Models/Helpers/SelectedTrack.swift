//
//  SelectedTrack.swift
//  map-project
//
//  Created by Brajan Kukk on 29.12.2024.
//

import Foundation

class SelectedTrack: ObservableObject {
    @Published var id: UUID? = nil
    
    @Published var startedAt: Date? = nil
}
