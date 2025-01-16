//
//  ParticleSystem.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//


import SwiftUI
import SwiftUI

struct ParticleSystem: View {
    let image: Image
    let color: Color
    
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(particles) { particle in
                image
                    .resizable()
                    .frame(width: particle.size, height: particle.size)
                    .foregroundColor(color)
                    .position(x: particle.x, y: particle.y)
                    .rotationEffect(.degrees(particle.rotation))
                    .opacity(particle.opacity)
                    .animation(.linear(duration: 0.02), value: particle.y)
            }
            .onReceive(timer) { _ in
                updateParticles(in: geometry.size)
            }
        }
    }
    
    private func updateParticles(in size: CGSize) {
        // Remove particles that are off screen or expired
        particles.removeAll(where: { $0.y > size.height + 50 || $0.lifetime <= 0 })
        
        // Add new particles if needed
        if particles.count < 50 {
            particles.append(Particle(in: size))
        }
        
        // Update existing particles
        for index in particles.indices {
            particles[index].update()
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var rotation: Double
    var rotationSpeed: Double
    var size: CGFloat
    var opacity: Double
    var lifetime: Double
    var velocity: CGFloat
    var horizontalVelocity: CGFloat
    
    mutating func update() {
        y += velocity
        x += horizontalVelocity
        rotation += rotationSpeed
        lifetime -= 0.02
        opacity = max(0, lifetime / 3.0) // Fade out as lifetime decreases
    }
    
    init(in size: CGSize) {
        self.x = CGFloat.random(in: 0..<size.width)
        self.y = -50 // Start above the screen
        self.rotation = Double.random(in: 0..<360)
        self.rotationSpeed = Double.random(in: -2...2)
        self.size = CGFloat.random(in: 15...25)
        self.lifetime = Double.random(in: 4.0...6.0)
        self.opacity = 1.0
        self.velocity = CGFloat.random(in: 1.5...3.0)
        self.horizontalVelocity = CGFloat.random(in: -1.0...1.0)
    }
}

#Preview {
    ParticleSystem(image: Image(systemName: "leaf.fill"), color: .green)
        .background(.black)
}
