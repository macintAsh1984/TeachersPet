//
//  Teachers_PetApp.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/5/24.
//

import SwiftUI

@main
struct Teachers_PetApp: App {
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            WelcomeScreen().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
