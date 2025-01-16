//
//  TimerState.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

class TimerState: ObservableObject {
    @Published var timeRemaining: TimeInterval {
        didSet {
            UserDefaults.standard.set(timeRemaining, forKey: "trialTimeRemaining")
        }
    }
    @Published var isActive: Bool = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        // Load saved time or set default (7 days)
        self.timeRemaining = UserDefaults.standard.double(forKey: "trialTimeRemaining")
        if self.timeRemaining == 0 {
            self.timeRemaining = 7 * 24 * 60 * 60
        }
        
        // Setup timer subscription
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
}
