//
//  ContentView.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//


import SwiftUI

struct MainView: View {
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var repository: LoginDataRepository
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            Group {
                switch locationViewModel.authorizationStatus {
                case .notDetermined:
                    RequestLocationView()
                        .environmentObject(locationViewModel)
                case .restricted:
                    Text("Location access restricted")
                case .denied:
                    Text("Location access denied")
                case .authorized, .authorizedAlways, .authorizedWhenInUse:
                    TrackingView()
                        .environmentObject(locationViewModel)
                        .environmentObject(user)
                        .environmentObject(repository)
                        .environmentObject(themeManager)
                @unknown default:
                    Text("Unknown authorization status")
                }
            }
            
            
        }

    }
}

#Preview {
    MainView()
}

