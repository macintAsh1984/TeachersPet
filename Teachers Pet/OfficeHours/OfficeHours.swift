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
                .foregroundColor(.white)
                .fontWeight(.semibold)
            Spacer()
                .frame(height: 10)
            HStack {
                Image(systemName: "studentdesk")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            
                if context.state.linePosition != 1 {
                    Text("You Are")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    Text("#\(context.state.linePosition)")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                } else {
                    Text("Up Next!")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        if context.state.linePosition != 1 {
                            Text("#\(context.state.linePosition)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Light Green"))
                        } else {
                            Text("Up Next!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Light Green"))
                        }
                    }
                    

                }
                
            //When Dynamic Island is a pill.
            } compactLeading: {
                Image(systemName: "studentdesk")
                    .foregroundColor(Color("Light Green"))
            } compactTrailing: {
                if context.state.linePosition != 1 {
                    Text("#\(context.state.linePosition)")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Light Green"))
                } else {
                    Text("Up Next!")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Light Green"))
                }
            
            //When Dynamic Island is a bubble.
            } minimal: {
                Text("#\(context.state.linePosition)")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Light Green"))
            }
        }
    }
}
