//
//  RootView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 3/13/24.
//

import SwiftUI
import Firebase

struct RootView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            if viewModel.userSession != nil {
                if let user = viewModel.currentUser {
                    //If the user did not create a course (aka doesn't have a coursename field in Firebase,
                    //take them to the Student Dashboard otherwise take them to the Instructor Dashboard.
                    if user.coursename.isEmpty {
                        StudentDashboard(email: .constant(user.email), joinCode: .constant(user.joincode))
                    } else {
                        InstructorDashboard()
                    }
                }
            } else {
                WelcomeScreen()
            }
        }
    }
}
