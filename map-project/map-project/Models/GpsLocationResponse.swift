//
//  GpsLocationResponse.swift
//  map-project
//
//  Created by Brajan Kukk on 28.12.2024.
//

import Foundation

struct GpsLocationResponse: Codable {
    var id: UUID
    var recordedAt: Date
    var latitude: Double
    var longitude: Double
    var accuracy: Double
    var altitude: Double
    var verticalAccuracy: Double
    var appUserId: UUID
    var gpsSessionId: UUID
    var gpsLocationTypeId: UUID
}
