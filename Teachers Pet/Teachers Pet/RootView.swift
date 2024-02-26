//
//  RootView.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/25/24.
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


