//
//  GpsSessionDelete.swift
//  map-project
//
//  Created by Brajan Kukk on 02.01.2025.
//

import Foundation

struct GpsSessionDelete: Codable {
    var id: UUID
    var name: String
    var description: String
    var recordedAt: Date
    var duration: Double
    var speed: Double
    var distance: Double
    var climb: Double
    var descent: Double
    var paceMin: Double
    var paceMax: Double
    var gpsSessionTypeId: UUID
    var appUserId: UUID
}
