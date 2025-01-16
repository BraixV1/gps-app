//
//  LiveActivtyIntent.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//

import Foundation
import ActivityKit
import WidgetKit
import AppIntents

struct AddWaypointIntent: LiveActivityIntent {
    @Parameter(title: "Activity ID")
    var activityId: String
    
    static var title: LocalizedStringResource = "Waypoint"
    static var description = IntentDescription("Add new Waypoint")
    
    init() {
        self.activityId = ""
    }
    
    init(activityId: String) {
        self.activityId = activityId
    }
    
    func perform() async throws -> some IntentResult {
        if let viewModel = AppIntentProvider.shared.getViewModel(forActivityId: activityId) {
            await MainActor.run {
                viewModel.addWaypoint()
            }
        }
        return .result()
    }
}

