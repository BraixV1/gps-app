//
//  Theme.swift
//  map-project
//
//  Created by Brajan Kukk on 04.01.2025.
//

import SwiftUI
import Foundation

struct Theme: Identifiable {
    
    
    let id: UUID = UUID()
    
    let title: String
    let description: String
    let Free: Bool
    

    let primaryGradient: LinearGradient
    
    let textColor: Color

    let buttonGradient: LinearGradient
    let buttonGradientSelected: LinearGradient
    

    let primaryColor: Color
    let secondaryColor: Color
    
    let walkingColor: Color
    let joggingColor: Color
    let runningColor: Color
    let polylineColor: Color
    
    var confettiEffect: ConfettiEffect = .noEffect
    

    
}

enum ConfettiEffect {
    case snowflakes
    case cherryBlossoms
    case autumnLeaves
    case sparkles
    case noEffect
}


let themes: [Theme] = [
    // Default Theme
    .init(
        title: "Default",
        description: "Default theme for TwiHiker",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "3C4487"), Color(hex: "8935CA"), Color(hex: "D5539E")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "3C4487"), Color(hex: "8935CA"), Color(hex: "D5539E")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "3C4487"), Color(hex: "8935CA"), Color(hex: "D5539E")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: .white,
        secondaryColor: .gray,
        walkingColor: Color(hex: "3C4487"),
        joggingColor: Color(hex: "8935CA"),
        runningColor: Color(hex: "D5539E"),
        polylineColor: Color(hex: "8936CA"),
        confettiEffect: .sparkles
    ),
    
    // Midnight Dream
    .init(
        title: "Midnight Dream",
        description: "A deep, dreamy theme with dark hues.",
        Free: false,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1c1936"), Color(hex: "1b1835")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1d1a37"), Color(hex: "1c1835")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1b1836"), Color(hex: "1f1c39")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "1c1936"),
        secondaryColor: Color(hex: "1b1936"),
        walkingColor: Color(hex: "1c1936"),
        joggingColor: Color(hex: "1b1836"),
        runningColor: Color(hex: "1f1c39"),
        polylineColor: Color(hex: "1d1a37")
    ),

    // Mystic Twilight
    .init(
        title: "Mystic Twilight",
        description: "Inspired by twilight's fading colors.",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1c1935"), Color(hex: "1d1a37")]),
            startPoint: .top,
            endPoint: .bottom
        ),
        textColor: .gray,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1b1836"), Color(hex: "1c1836")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1b1935"), Color(hex: "1f1c39")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "1c1836"),
        secondaryColor: Color(hex: "1b1836"),
        walkingColor: Color(hex: "1c1835"),
        joggingColor: Color(hex: "1b1936"),
        runningColor: Color(hex: "1c1836"),
        polylineColor: Color(hex: "1d1a37")
    ),
    
    // Strawberry Lemonade
    .init(
        title: "Strawberry Lemonade",
        description: "Vibrant and refreshing with citrus tones.",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FFE33F"), Color(hex: "FF9933"), Color(hex: "FF2293")]),
            startPoint: .top,
            endPoint: .bottom
        ),
        textColor: .black,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FFE33F"), Color(hex: "FF9933")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF9933"), Color(hex: "FF2293")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "FFE33F"),
        secondaryColor: Color(hex: "FF9933"),
        walkingColor: Color(hex: "FF9933"),
        joggingColor: Color(hex: "FF2293"),
        runningColor: Color(hex: "FFE33F"),
        polylineColor: Color(hex: "FF2293")
    ),

    // Deep Cosmos
    .init(
        title: "Deep Cosmos",
        description: "A cosmic palette of blues and purples.",
        Free: false,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "001AF5"), Color(hex: "811FEE"), Color(hex: "F92EDC")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "811FEE"), Color(hex: "F92EDC")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "F92EDC"), Color(hex: "001AF5")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "811FEE"),
        secondaryColor: Color(hex: "F92EDC"),
        walkingColor: Color(hex: "811FEE"),
        joggingColor: Color(hex: "F92EDC"),
        runningColor: Color(hex: "001AF5"),
        polylineColor: Color(hex: "F92EDC"),
        confettiEffect: .sparkles
    ),// Forest Breeze
    .init(
        title: "Forest Breeze",
        description: "Inspired by lush forests and morning dew",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "2D5A27"), Color(hex: "8FCA5B"), Color(hex: "C5E063")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "2D5A27"), Color(hex: "8FCA5B")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "8FCA5B"), Color(hex: "C5E063")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "2D5A27"),
        secondaryColor: Color(hex: "8FCA5B"),
        walkingColor: Color(hex: "2D5A27"),
        joggingColor: Color(hex: "8FCA5B"),
        runningColor: Color(hex: "C5E063"),
        polylineColor: Color(hex: "8FCA5B"),
        confettiEffect: .autumnLeaves
    ),

    // Sunset Horizon
    .init(
        title: "Sunset Horizon",
        description: "Warm colors inspired by a beautiful sunset",
        Free: false,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF4E50"), Color(hex: "FC913A"), Color(hex: "F9D423")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF4E50"), Color(hex: "FC913A")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FC913A"), Color(hex: "F9D423")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "FF4E50"),
        secondaryColor: Color(hex: "FC913A"),
        walkingColor: Color(hex: "FF4E50"),
        joggingColor: Color(hex: "FC913A"),
        runningColor: Color(hex: "F9D423"),
        polylineColor: Color(hex: "FC913A")
    ),

    // Ocean Depths
    .init(
        title: "Ocean Depths",
        description: "Deep blues inspired by ocean waters",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1A2980"), Color(hex: "26D0CE")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1A2980"), Color(hex: "26D0CE")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "26D0CE"), Color(hex: "1A2980")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "1A2980"),
        secondaryColor: Color(hex: "26D0CE"),
        walkingColor: Color(hex: "1A2980"),
        joggingColor: Color(hex: "26D0CE"),
        runningColor: Color(hex: "26D0CE"),
        polylineColor: Color(hex: "1A2980")
    ),

    // Northern Lights
    .init(
        title: "Northern Lights",
        description: "Inspired by the aurora borealis",
        Free: false,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1B4F72"), Color(hex: "48C9B0"), Color(hex: "58D68D")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "1B4F72"), Color(hex: "48C9B0")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "48C9B0"), Color(hex: "58D68D")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "1B4F72"),
        secondaryColor: Color(hex: "48C9B0"),
        walkingColor: Color(hex: "1B4F72"),
        joggingColor: Color(hex: "48C9B0"),
        runningColor: Color(hex: "58D68D"),
        polylineColor: Color(hex: "48C9B0"),
        confettiEffect: .snowflakes
    ),

    // Cherry Blossom
    .init(
        title: "Cherry Blossom",
        description: "Soft pink tones of spring flowers",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FFB7B2"), Color(hex: "FF9AA2"), Color(hex: "FF6B6B")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        textColor: .black,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FFB7B2"), Color(hex: "FF9AA2")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF9AA2"), Color(hex: "FF6B6B")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "FFB7B2"),
        secondaryColor: Color(hex: "FF9AA2"),
        walkingColor: Color(hex: "FFB7B2"),
        joggingColor: Color(hex: "FF9AA2"),
        runningColor: Color(hex: "FF6B6B"),
        polylineColor: Color(hex: "FF9AA2"),
        confettiEffect: .cherryBlossoms
    ),
    
    // Solar Flare
    .init(
        title: "Solar Flare",
        description: "Intense fiery tones with bursts of energy",
        Free: false,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF4500"), Color(hex: "FF6347"), Color(hex: "FFD700")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF4500"), Color(hex: "FFD700")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF6347"), Color(hex: "FFD700")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "FF4500"),
        secondaryColor: Color(hex: "FFD700"),
        walkingColor: Color(hex: "FF6347"),
        joggingColor: Color(hex: "FF4500"),
        runningColor: Color(hex: "FFD700"),
        polylineColor: Color(hex: "FF4500")
    ),

    // Arctic Chill
    .init(
        title: "Arctic Chill",
        description: "Cool and calming icy blues",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "00BFFF"), Color(hex: "87CEFA"), Color(hex: "E0FFFF")]),
            startPoint: .top,
            endPoint: .bottom
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "00BFFF"), Color(hex: "87CEFA")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "87CEFA"), Color(hex: "E0FFFF")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "00BFFF"),
        secondaryColor: Color(hex: "87CEFA"),
        walkingColor: Color(hex: "E0FFFF"),
        joggingColor: Color(hex: "87CEFA"),
        runningColor: Color(hex: "00BFFF"),
        polylineColor: Color(hex: "00BFFF")
    ),

    // Tropical Sunrise
    .init(
        title: "Tropical Sunrise",
        description: "Vibrant tropical hues of dawn",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF7E5F"), Color(hex: "FEB47B"), Color(hex: "FFD194")]),
            startPoint: .top,
            endPoint: .bottom
        ),
        textColor: .black,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FF7E5F"), Color(hex: "FEB47B")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "FEB47B"), Color(hex: "FFD194")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "FF7E5F"),
        secondaryColor: Color(hex: "FEB47B"),
        walkingColor: Color(hex: "FFD194"),
        joggingColor: Color(hex: "FEB47B"),
        runningColor: Color(hex: "FF7E5F"),
        polylineColor: Color(hex: "FF7E5F")
    ),

    // Ember Glow
    .init(
        title: "Ember Glow",
        description: "Warm glowing embers of a fading fire",
        Free: false,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "D72638"), Color(hex: "EB6A5A"), Color(hex: "FFD275")]),
            startPoint: .top,
            endPoint: .bottom
        ),
        textColor: .white,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "D72638"), Color(hex: "FFD275")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "EB6A5A"), Color(hex: "FFD275")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "D72638"),
        secondaryColor: Color(hex: "FFD275"),
        walkingColor: Color(hex: "EB6A5A"),
        joggingColor: Color(hex: "D72638"),
        runningColor: Color(hex: "FFD275"),
        polylineColor: Color(hex: "EB6A5A")
    ),

    // Zen Garden
    .init(
        title: "Zen Garden",
        description: "Tranquil greens inspired by nature",
        Free: true,
        primaryGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "355C7D"), Color(hex: "6C5B7B"), Color(hex: "C06C84")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        textColor: .black,
        buttonGradient: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "355C7D"), Color(hex: "6C5B7B")]),
            startPoint: .leading,
            endPoint: .trailing
        ),
        buttonGradientSelected: LinearGradient(
            gradient: Gradient(colors: [Color(hex: "6C5B7B"), Color(hex: "C06C84")]),
            startPoint: .bottom,
            endPoint: .top
        ),
        primaryColor: Color(hex: "355C7D"),
        secondaryColor: Color(hex: "6C5B7B"),
        walkingColor: Color(hex: "C06C84"),
        joggingColor: Color(hex: "6C5B7B"),
        runningColor: Color(hex: "355C7D"),
        polylineColor: Color(hex: "355C7D")
    )

]

