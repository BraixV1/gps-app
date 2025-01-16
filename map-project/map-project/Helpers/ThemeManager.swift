//
//  ThemeManager.swift
//  map-project
//
//  Created by Brajan Kukk on 04.01.2025.
//
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = themes[0]
    @AppStorage("selectedThemeIndex") private var selectedThemeIndex: Int = 0
    
    init() {
        if selectedThemeIndex >= 0 && selectedThemeIndex < themes.count {
            self.currentTheme = themes[selectedThemeIndex]
        } else {
            self.currentTheme = themes[0]
            selectedThemeIndex = 0
        }
    }
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            selectedThemeIndex = index
        }
    }
    

    func getTheme(at index: Int) -> Theme {
        guard index >= 0 && index < themes.count else {
            return themes[0]
        }
        return themes[index]
    }
}
