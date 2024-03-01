//
//  ContentView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/5/24.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @State var navigateToStudentCreateAccount = false
    @State var navigateToInstructorCreateAccount = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome To Teacher's Pet")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("I am a...")
                    .font(.headline)
                Spacer()
                    .frame(height: 20)
                
                Button {
                    navigateToStudentCreateAccount = true
                } label: {
                    Text("Student")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .controlSize(.large)
                
                Button {
                    navigateToInstructorCreateAccount = true
                } label: {
                    Text("Instructor")
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding()
            .background(Color("AppBackgroundColor"))
            .preferredColorScheme(.light)
            .navigationDestination(isPresented: $navigateToStudentCreateAccount) {
                CreateAccount(studentview: $navigateToStudentCreateAccount, instructorView: $navigateToInstructorCreateAccount)
            }
            .navigationDestination(isPresented: $navigateToInstructorCreateAccount) {
                CreateAccount(studentview: $navigateToStudentCreateAccount, instructorView: $navigateToInstructorCreateAccount)
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
