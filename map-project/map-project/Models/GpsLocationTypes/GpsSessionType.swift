//
//  GpsSessionType.swift
//  map-project
//
//  Created by Brajan Kukk on 28.12.2024.
//
import Foundation

struct GpsSessionType: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var description: String
    var paceMin: Double
    var paceMax: Double
}
