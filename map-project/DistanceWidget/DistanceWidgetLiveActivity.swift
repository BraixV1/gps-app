//
//  DistanceWidgetLiveActivity.swift
//  DistanceWidget
//
//  Created by Brajan Kukk on 15.12.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DistanceWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        
        
        var distance: Double
        
        var elapsedTime: Double
        
        var pace: String?
    }
}

struct DistanceWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DistanceWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "3C4487"),
                        Color(hex: "8935CA"),
                        Color(hex: "D5539E")
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                VStack {
                    Text("TwiHiker")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 7)
                        .padding(.top, 5)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "F92EDC"), Color(hex: "811FEE"),
                                                            Color(hex: "001AF5")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .mask(
                                Text("TwiHiker")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 7)
                                    .padding(.top, 5)

                            )
                        )
                    Spacer()
                }

                HStack {
                    Button(intent: AddWaypointIntent(activityId: context.activityID)) {
                        Image(systemName: "mappin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .yellow]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    Button(intent: AddCheckPointIntent(activityId: context.activityID)) {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(
                                RadialGradient(
                                    gradient: Gradient(colors: [.pink, .purple]),
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 50
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    VStack {
                        Text(formatElapsedTime(elapsedTime: context.state.elapsedTime))
                            .foregroundColor(.white)
                        Text(String(format: "Total Distance: %.2f km", context.state.distance / 1000))
                            .foregroundColor(.white)
                            // Ensure text is visible on gradient
                        Text("Pace: \(context.state.pace ?? "0min/km")")
                            .foregroundColor(.white)
                    }

                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .padding(.trailing, 10)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.state.distance)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.distance)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Distance: \(context.state.distance)")
                    // more content
                }
            } compactLeading: {
                Text("\(context.state.distance)")
            } compactTrailing: {
                Text("\(context.state.distance)")
            } minimal: {
                Text("\(context.state.distance)")
            }
            .keylineTint(Color.red)
        }
    }
    
    private func formatElapsedTime(elapsedTime: TimeInterval) -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

extension DistanceWidgetAttributes {
    fileprivate static var preview: DistanceWidgetAttributes {
        DistanceWidgetAttributes()
    }
}

extension DistanceWidgetAttributes.ContentState {
    fileprivate static var D56: DistanceWidgetAttributes.ContentState {
        DistanceWidgetAttributes.ContentState(distance: 5.6, elapsedTime: 0, pace: "2min/km")
     }
}

#Preview("Notification", as: .content, using: DistanceWidgetAttributes.preview) {
   DistanceWidgetLiveActivity()
} contentStates: {
    DistanceWidgetAttributes.ContentState.D56
}
