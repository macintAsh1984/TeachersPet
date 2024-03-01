//
//  OfficeHoursViewModel.swift
//  Teachers Pet
//
//  Created by Sai Ganesh Chamarty on 2/28/24.
//

import Foundation

class OfficeHoursViewModel: ObservableObject {
    @Published var className: String = ""
    @Published var month: String
    @Published var day: Int
    @Published var startHour: Int
    @Published var endHour: Int
    @Published var buildingName: String = ""
    @Published var roomNumber: Int
    @Published var profName: String = ""
    
    init(className: String, month: String, day: Int, startHour: Int, endHour: Int, buildingName: String, roomNumber: Int, profName: String) {
        self.className = className
        self.month = month
        self.day = day
        self.startHour = startHour
        self.endHour = endHour
        self.buildingName = buildingName
        self.roomNumber = roomNumber
        self.profName = profName
    }
}
