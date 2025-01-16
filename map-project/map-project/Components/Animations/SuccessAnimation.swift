//
//  SuccessAnimation.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//


import SwiftUI

struct SuccessAnimation: View {
    @Binding var isShowing: Bool
    let theme: Theme
    let onComplete: () -> Void
    
    @State private var rocketOffset: CGFloat = 0
    @State private var textOpacity: Double = 0
    @State private var scale: CGFloat = 1
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .transition(.opacity)
            
            // Particle effects
            ParticleSystem(
                image: Image(systemName: "star.fill"),
                color: theme.secondaryColor
            )
            
            VStack {
                // Rocket
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 240, height: 240)
                    .foregroundColor(theme.secondaryColor)
                    .rotationEffect(.degrees(-90))
                    .offset(y: rocketOffset)
                    .scaleEffect(scale)
                
                // Success text
                Text("Pro Trial Activated! 🎉")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .padding(.top, 40)
            }
        }
        .onAppear {
            animate()
        }
    }
    
    private func animate() {
        // Initial state
        rocketOffset = UIScreen.main.bounds.height / 2
        textOpacity = 0
        scale = 1
        
        // Rocket animation
        withAnimation(.easeOut(duration: 1.0)) {
            rocketOffset = -UIScreen.main.bounds.height / 2
            scale = 0.5
        }
        
        // Text fade in
        withAnimation(.easeIn.delay(0.5)) {
            textOpacity = 1
        }
        
        // Dismiss after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                isShowing = false
                onComplete()
            }
        }
    }
}

#Preview {
    @Previewable @State var show = true
    SuccessAnimation(isShowing: $show, theme: ThemeManager().currentTheme) {    }
}
