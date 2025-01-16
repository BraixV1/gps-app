//
//  BackGround.swift
//  map-project
//
//  Created by Brajan Kukk on 01.01.2025.
//

import SwiftUI

struct BackGround : View {
    
    @State var image: String
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var maxHeight: CGFloat = 350
    
    
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: maxHeight)
                .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 155, bottomTrailingRadius: 155))
                .overlay(
                    UnevenRoundedRectangle(bottomLeadingRadius: 155, bottomTrailingRadius: 155).stroke(
                        themeManager.currentTheme.primaryGradient,
                        lineWidth: 4
                    )
                )
                .ignoresSafeArea()
                .shadow(radius: 10)
                .padding(.bottom, 20)
            Spacer()
        }
    }
    
}

#Preview {
    BackGround(image: "HikingDefault")
        .environmentObject(ThemeManager())
}
