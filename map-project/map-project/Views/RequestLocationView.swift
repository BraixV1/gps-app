//
//  RequestLocationView.swift
//  map-project
//
//  Created by Brajan Kukk on 15.12.2024.
//

import SwiftUI

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        Button("Allow tracking!") {
            locationViewModel.requestPermission()
        }
    }
}

#Preview {
    // NB! This is needed before first run!
    // Navigate to capabilities section and click "+" on upper right corner.
    // Dbl clikc on Choose Bakground Modes - new section is addedd to settings.
    // to reset - run from terminal: xcrun simctl privacy booted reset all
    
    RequestLocationView()
        //.environmentObject(LocationViewModel())
}
