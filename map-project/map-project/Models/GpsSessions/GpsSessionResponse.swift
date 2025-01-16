//
//  GpsSessionResponse.swift
//  map-project
//
//  Created by Brajan Kukk on 28.12.2024.
//

import Foundation

struct GpsSessionResponse: Codable {
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
