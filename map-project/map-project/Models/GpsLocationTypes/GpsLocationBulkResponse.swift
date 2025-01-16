//
//  GpsLocationBulkResponse.swift
//  map-project
//
//  Created by Brajan Kukk on 06.01.2025.
//
import Foundation

struct GpsLocationBulkResponse: Codable {
    
    var locationsAdded: Double
    var locationsReceived: Double
    var gpsSessionId: UUID
    
}
