//
//  ShimmerEffect.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ShimmerEffect: ViewModifier {
    let theme: Theme
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    theme.primaryGradient
                        .opacity(0.5)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: .clear, location: 0),
                                            .init(color: .white.opacity(0.7), location: 0.45),
                                            .init(color: .white.opacity(0.7), location: 0.55),
                                            .init(color: .clear, location: 1)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: -geometry.size.width)
                                .offset(x: geometry.size.width * phase)
                        )
                        .blendMode(.softLight)
                }
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}
