//
//  RootView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/26/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if viewModel.userSession != nil {
            Instructorview()
        } else {
            WelcomeScreen()
        }
    }
    
}
