//
//  OfficeHoursLiveActivity.swift
//  OfficeHours
//
//  Created by Ashley Valdez on 3/4/24.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct OHLiveActivityView: View {
    let context: ActivityViewContext<OfficeHoursAttribute>
    
    var body: some View {
        VStack {
            Text("You're in line!")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
                .frame(height: 10)
            Text("You are #\(context.state.linePosition)")
                .fontWeight(.medium)
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .top, endPoint: .bottom)
            )
    }
}

struct OfficeHoursLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OfficeHoursAttribute.self) { context in
            OHLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.linePosition)")
                    // more content
                }
            } compactLeading: {
                Image(systemName: "studentdesk")
            } compactTrailing: {
                Text("# \(context.state.linePosition)")
            } minimal: {
                Text("# \(context.state.linePosition)")
            }
        }
    }
}

