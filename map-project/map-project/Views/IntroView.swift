//
//  IntroView.swift
//  map-project
//
//  Created by Brajan Kukk on 04.01.2025.
//

import SwiftUI

struct IntroView: View {
    
    @State private var selectedItem: Item = items.first!
    @State private var introItems: [Item] = items
    @State private var activeIndex: Int = 0
    @State private var isVisible = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "3C4487"), Color(hex: "8935CA"), Color(hex: "D5539E")]),
                startPoint: .bottom,
                endPoint: .top
            )
            BackGround(image: "HikingGreeting", maxHeight: 450)
            
            VStack(spacing: 0) {
                
                Button(action: {
                    updateItem(isForward: false)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title.bold())
                        .foregroundStyle(.green.gradient)
                        .contentShape(.rect)
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(selectedItem.id != introItems.first?.id ? 1 : 0)
                
                ZStack {
                    ForEach(introItems) { item in
                        AnimatedIconView(item)
                    }
                }
                .frame(height: 250)
                .frame(maxHeight: .infinity )
                
                VStack(spacing: 6) {
                    
                    HStack(spacing: 4) {
                        ForEach(introItems) { item in
                            Capsule()
                                .fill(selectedItem.id == item.id ? Color.primary : .gray)
                                .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
                        }
                        
                    }
                    .padding(.bottom, 15)
                    
                    Text(selectedItem.title)
                        .font(.title.bold())
                        .contentTransition(.numericText())
                    
                    Button {
                        isVisible = updateItem(isForward: true)
                        
                    }  label: {
                        Text(selectedItem.id == introItems.last?.id ? "Get started" : "Next ")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .frame(width: 250)
                            .padding(.vertical, 12)
                        
                    }
                    .background(.green)
                    .cornerRadius(100)
                }
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
            }
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 2), value: isVisible)
    }
    
    
    @ViewBuilder
    func AnimatedIconView(_ item: Item) -> some View {
        let isSelected = selectedItem.id == item.id
        
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.shadow(.drop(radius:10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(.green.gradient, in: .rect(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: 1, y: 1)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: -1, y: 1)
                    .padding(-3)
                    .opacity(selectedItem.id == item.id ? 1 : 0)
            }
            .rotationEffect(.init(degrees: -item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x: item.offset)
            .rotationEffect(.init(degrees: item.rotation))
            .zIndex(isSelected ? 2 : item.zindex)
    }
    
    func updateItem(isForward: Bool) -> Bool {
        
        guard isForward ? activeIndex != introItems.count - 1 : activeIndex != 0 else { return false }
        
        var fromIndex: Int
        var extraOffset: CGFloat
        
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }
        
        
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = introItems[activeIndex].extraOffset
        } else {
            extraOffset = introItems[activeIndex].extraOffset
            fromIndex = activeIndex + 1 
        }
        
        
        Task { [fromIndex, extraOffset] in
            withAnimation(.bouncy(duration: 3)) {
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                introItems[fromIndex].offset = introItems[activeIndex].offset
                
                introItems[activeIndex].offset = extraOffset
                
                
                introItems[fromIndex].zindex = 1
            }
                
            try? await Task.sleep(for: .seconds(0.1))
                
            withAnimation(.bouncy(duration: 2.9)) {
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].anchor = .center
                introItems[activeIndex].offset = .zero
                
                
                selectedItem = introItems[activeIndex]
                
            }
        }
        
        return true
    }
}

#Preview {
    IntroView()
        .environmentObject(ThemeManager())
}

