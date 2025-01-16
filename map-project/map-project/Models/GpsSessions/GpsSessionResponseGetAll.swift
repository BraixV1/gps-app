//
//  GpsSessionResponseGetAll.swift
//  map-project
//
//  Created by Brajan Kukk on 29.12.2024.
//
import Foundation

struct GpsSessionResponseGetAll: Codable, Identifiable {
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
    var gpsSessionType: String
    var gpsLocationsCount: Double
    var userFirstLastName: String 
}
