//
//  GpsSession.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//

import Foundation

struct GpsSession: Codable {
    var name: String
    var description: String
    var gpsSessionTypeId: UUID?
    var recordedAt: Date
    var paceMin: Double
    var paceMax: Double
}
