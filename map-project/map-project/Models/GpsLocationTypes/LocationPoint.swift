//
//  LocationPoint.swift
//  map-project
//
//  Created by Brajan Kukk on 08.01.2025.
//
import Foundation
import MapKit

struct LocationPoint: Identifiable {
    let id: UUID
    let location: CLLocation
    let timestamp: Date
    let gpsLocationTypeId: UUID
    var isSent: Bool
    
    var toGpsLocation: GpsLocation {
        return GpsLocation(
            recordedAt: timestamp,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            accuracy: location.horizontalAccuracy,
            altitude: location.altitude,
            verticalAccuracy: location.verticalAccuracy,
            gpsLocationTypeId: gpsLocationTypeId
        )
    }
}
