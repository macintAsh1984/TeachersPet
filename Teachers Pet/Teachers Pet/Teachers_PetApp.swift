//
//  Teachers_PetApp.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/5/24.
//

import SwiftUI
import Firebase

@main
struct Teachers_PetApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    //Configure firebase.
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
           RootView().environmentObject(viewModel)
        }
    }
}
