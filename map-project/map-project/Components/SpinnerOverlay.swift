//
//  SpinnerOverlay.swift
//  map-project
//
//  Created by Brajan Kukk on 01.01.2025.
//
import SwiftUI

struct SpinnerOverlay: View {
    @State private var isRotating = false
    
    @EnvironmentObject var themeManager: ThemeManager// Controls the animation

    var body: some View {
        ZStack {
            // Background
            Color.white.opacity(0.6)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Rotating Circle (Planet)
                ZStack {
                    Image(systemName: "globe.europe.africa.fill")
                        
                       .resizable()
                       .scaledToFit()
                       //.background(Color.blue)
                       .foregroundColor(themeManager.currentTheme.primaryColor)
                       .frame(width: 200, height: 200) // Adjust size to match the border
                       .clipShape(Circle()) // Ensure it's circular
                       .rotationEffect(Angle(degrees: isRotating ? 360 : 0)) // Animation
                       .animation(
                           Animation.linear(duration: 4)
                               .repeatForever(autoreverses: false),
                           value: isRotating
                       )
                       .overlay(
                        themeManager.currentTheme.primaryGradient
                        .mask(
                            Image(systemName: "globe.europe.africa.fill")
                                
                               .resizable()
                               .scaledToFit()
                               //.background(Color.blue)
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                               .frame(width: 200, height: 200) // Adjust size to match the border
                               .clipShape(Circle()) // Ensure it's circular
                               .rotationEffect(Angle(degrees: isRotating ? 360 : 0)) // Animation
                               .animation(
                                   Animation.linear(duration: 4)
                                       .repeatForever(autoreverses: false),
                                   value: isRotating
                               )
                        )
                       )
                    

                    Image(systemName: "airplane")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                        .frame(width: 50, height: 50)
                        .scaleEffect(CGSize(width: -1, height: 1) )
                        .offset(y: -120)
                        .rotationEffect(Angle(degrees: isRotating ? -360 : 0))
                        .animation(
                            Animation.linear(duration: 4)
                                .repeatForever(autoreverses: false),
                            value: isRotating
                        )
                }
                
                Text("Loading")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.clear)
                    .overlay(
                        themeManager.currentTheme.buttonGradient
                        .mask(
                            Text("Loading")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                        )
                    )
                    Spacer()
            }
        }
        .onAppear {
            isRotating = true
        }
    }
}

#Preview {
    SpinnerOverlay()
        .environmentObject(ThemeManager())
}

