//
//  OfficeHours.swift
//  OfficeHours
//
//  Created by Ashley Valdez on 3/4/24.
//

import Foundation
import ActivityKit

struct OfficeHoursAttribute: ActivityAttributes {
    public typealias LiveActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var linePosition: Int
    }
    
    var activityTitle: String
}
