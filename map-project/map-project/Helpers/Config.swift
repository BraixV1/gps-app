//
//  Config.swift
//  map-project
//
//  Created by Brajan Kukk on 08.01.2025.
//
import SwiftUI


class Config: ObservableObject {
    
    @Published var walkSpeed: Double = 2
    @Published var jogSpeed: Double = 4
    @Published var runSpeed: Double = 6
    
    @Published var height: Double = 175
    
    @Published var weight: Double = 75
    
    @Published var stepLenght: Double = 50
    
    
    
    init(walkSpeed: Double = 2, jogSpeed: Double = 4, runSpeed: Double = 6, height: Double = 175, weight: Double = 75, stepLenght: Double = 50) {
        self.walkSpeed = walkSpeed
        self.jogSpeed = jogSpeed
        self.runSpeed = runSpeed
        self.height = height
        self.weight = weight
        self.stepLenght = stepLenght
    }
    
    
    
}
