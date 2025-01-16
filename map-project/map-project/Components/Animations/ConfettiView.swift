//
//  ConfettiView.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ConfettiView: View {
    let effect: ConfettiEffect
    
    var body: some View {
        ZStack {
            if effect == .snowflakes {
                ParticleSystem(image: Image(systemName: "snowflake"), color: .white)
            } else if effect == .cherryBlossoms {
                ParticleSystem(image: Image("CherryLeaf"), color: Color.pink)
            } else if effect == .autumnLeaves {
                ParticleSystem(image: Image("leaf"), color: .orange)
            } else if effect == .sparkles {
                ParticleSystem(image: Image(systemName: "sparkles"), color: .yellow)
            } else {
                EmptyView()
            }
        }
    }
}
