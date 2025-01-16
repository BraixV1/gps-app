//
//  Tab.swift
//  map-project
//
//  Created by Brajan Kukk on 08.01.2025.
//


enum Tab {
    case home, activities, profile, settings
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .activities: return "figure.run"
        case .profile: return "person.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .activities: return "Activities"
        case .profile: return "Profile"
        case .settings: return "Settings"
        }
    }
}
