//
//  OfficeHoursLiveActivity.swift
//  OfficeHours
//
//  Created by Ashley Valdez on 3/4/24.
//

#if canImport(ActvityKit)
import ActivityKit
#endif

import WidgetKit
import SwiftUI

struct OHLiveActivityView: View {
    let context: ActivityViewContext<OfficeHoursAttribute>
    
    var body: some View {
        VStack {
            Text("Office Hours")
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
                .frame(height: 10)
            HStack {
                Image(systemName: "studentdesk")
                    .font(.largeTitle)
                Text("You Are")
                    .font(.title2)
                    .fontWeight(.medium)
                Text("#\(context.state.linePosition)")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .padding(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("Light Green"), Color("Teal")]), startPoint: .leading, endPoint: .trailing)
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
                DynamicIslandExpandedRegion(.center) {
                    Text("Office Hours")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        Text("You Are")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("#\(context.state.linePosition)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Light Green"))
                    }
                    

                }
            } compactLeading: {
                Image(systemName: "studentdesk")
                    .foregroundColor(Color("Light Green"))
            } compactTrailing: {
                Text("#\(context.state.linePosition)")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Light Green"))
            } minimal: {
                Text("#\(context.state.linePosition)")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Light Green"))
            }
        }
    }
}
