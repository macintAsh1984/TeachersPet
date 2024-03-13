//
//  ContentView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/5/24.
//

import SwiftUI
let appBackgroundColor = Color("AppBackgroundColor")

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
                
                Image("Welcome Icon") // adds the app logo on the welcome screen
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                    .cornerRadius(5)
                
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
            .background(appBackgroundColor)
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $navigateToStudentCreateAccount) {
                CreateAccount(isStudent: $navigateToStudentCreateAccount, instructorView: $navigateToInstructorCreateAccount)
            }
            .navigationDestination(isPresented: $navigateToInstructorCreateAccount) {
                CreateAccount(isStudent: $navigateToStudentCreateAccount, instructorView: $navigateToInstructorCreateAccount)
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
