//
//  Waypoint.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//

import Foundation
import CoreLocation


struct Waypoint: Identifiable {
    let id: UUID = UUID()
    let type: EWayPointType
    let location: CLLocation
    let timestamp: Date
    
    init(location: CLLocation, type: EWayPointType) {
        self.location = location
        self.timestamp = Date()
        self.type = type
    }
}

enum EWayPointType: String {
    case waypoint = "WP"
    case checkpoint = "CP"
}
