//
//  WarningBox.swift
//  map-project
//
//  Created by Brajan Kukk on 09.01.2025.
//
import SwiftUI

struct WarningBox: View {
    @Binding var confirmed: Bool
    @Binding var appear: Bool
    var warningText: String
    
    var body: some View {
        if appear {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            appear = false
                        }
                    }
                
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("Warning")
                        .font(.title2.bold())
                    
                    Text(warningText)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation {
                                confirmed = true
                                appear = false
                            }
                        }) {
                            Text("Yes")
                                .frame(width: 100)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            withAnimation {
                                confirmed = false
                                appear = false
                            }
                        }) {
                            Text("No")
                                .frame(width: 100)
                                .padding(.vertical, 12)
                                .background(Color.secondary.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(radius: 15)
                )
                .padding(40)
                .transition(.scale)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    WarningBox(
        confirmed: .constant(false),
        appear: .constant(true),
        warningText: "You are about to close the app"
    )
}
