//
//  GpsLocation.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//
import Foundation

struct GpsLocation: Codable {
    var recordedAt: Date
    var latitude: Double
    var longitude: Double
    var accuracy: Double
    var altitude: Double
    var verticalAccuracy: Double
    var gpsLocationTypeId: UUID
}
