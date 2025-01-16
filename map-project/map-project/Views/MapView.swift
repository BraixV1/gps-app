//
//  MapView.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//

import MapKit
import SwiftUI
import MapKit
import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    let track: [CLLocation]
    let checkpoints: [Waypoint]
    let waypoint: Waypoint?
    let colored: Bool
    let config: Config
    
    var body: some View {
        Map {
            if track.count > 1 {
                if colored{
                    
                    ForEach(colorSegments(), id: \.id) { segment in
                        MapPolyline(coordinates: segment.coordinates)
                            .stroke(segment.color, lineWidth: 4)
                    }
                } else {
                    MapPolyline(
                        coordinates: track.map {
                            $0.coordinate
                        }
                    )
                    .stroke(themeManager.currentTheme.polylineColor, lineWidth: 4)
                }



            }
            
            ForEach(checkpoints) { checkpoint in
                Marker("Checkpoint", coordinate: checkpoint.location.coordinate)
                    .tint(.black)
            }
            
            if let unwrappedWaypoint = waypoint {
                Marker("Waypoint", coordinate: unwrappedWaypoint.location.coordinate)
                    .tint(.red)
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapScaleView()
            MapUserLocationButton()
        }
        .mapControlVisibility(.visible)
        .mapStyle(.hybrid(elevation: .realistic, showsTraffic: true))
    }
    
    private func colorSegments() -> [Segment] {
        var segments: [Segment] = []
        guard track.count > 1 else { return segments }
        
        for i in 1..<track.count {
            let start = track[i - 1]
            let end = track[i]
            
            let distance = start.distance(from: end)
            let time = end.timestamp.timeIntervalSince(start.timestamp)
            let speed = time > 0 ? distance / time : 0
            let color: Color
            if speed < config.walkSpeed {
                color = themeManager.currentTheme.walkingColor
            } else if speed < config.jogSpeed {
                color = themeManager.currentTheme.joggingColor
            } else {
                color = themeManager.currentTheme.runningColor
            }
            
            segments.append(Segment(
                id: UUID(),
                coordinates: [start.coordinate, end.coordinate],
                color: color
            ))
        }
        
        return segments
    }
    
    struct Segment: Identifiable {
        let id: UUID
        let coordinates: [CLLocationCoordinate2D]
        let color: Color
    }
}

#Preview {
    MapView(track: [], checkpoints: [], waypoint: nil, colored: false, config: Config())
}

