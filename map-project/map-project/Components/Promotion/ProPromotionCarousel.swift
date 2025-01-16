//
//  ProPromotionBanner.swift
//  map-project
//
//  Created by Brajan Kukk on 05.01.2025.
//
import SwiftUI

struct ProPromotionCarousel: View {
    let theme: Theme
    let action: () -> Void
    
    private let promotions = [
        PromoItem(
            icon: "crown.fill",
            iconColor: .yellow,
            title: "Upgrade to Pro",
            description: "Get access to premium themes and more!"
        ),
        PromoItem(
            icon: "map.fill",
            iconColor: .green,
            title: "Offline Maps",
            description: "Download trails for offline access"
        ),
        PromoItem(
            icon: "star.fill",
            iconColor: .orange,
            title: "Premium Features",
            description: "Advanced tracking and statistics"
        ),
        PromoItem(
            icon: "bell.fill",
            iconColor: .blue,
            title: "Trail Alerts",
            description: "Get notified about trail conditions"
        )
    ]
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    
    // Timer for auto-scrolling
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<promotions.count, id: \.self) { index in
                    PromoCard(
                        theme: theme,
                        item: promotions[index],
                        action: action
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default page indicator
            .frame(height: 100)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % promotions.count
                }
            }
            
            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<promotions.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? theme.primaryColor : theme.primaryColor.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentIndex)
                }
            }
            .padding(.top, 8)
        }
    }
}
