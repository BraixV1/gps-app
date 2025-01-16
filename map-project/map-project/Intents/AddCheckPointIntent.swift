//
//  AddCheckPointIntent.swift
//  map-project
//
//  Created by Brajan Kukk on 03.01.2025.
//

import Foundation
import ActivityKit
import WidgetKit
import AppIntents

struct AddCheckPointIntent: LiveActivityIntent {
    @Parameter(title: "Activity ID")
    var activityId: String
    
    static var title: LocalizedStringResource = "Checkpoint"
    static var description = IntentDescription("Add new Checkpoint")
    
    init() {
        self.activityId = ""
    }
    
    init(activityId: String) {
        self.activityId = activityId
    }
    
    func perform() async throws -> some IntentResult {
        if let viewModel = AppIntentProvider.shared.getViewModel(forActivityId: activityId) {
            await MainActor.run {
                viewModel.addCheckPoint()
            }
        }
        return .result()
    }
}
