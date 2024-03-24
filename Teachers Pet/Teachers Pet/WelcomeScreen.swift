//
//  ContentView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/5/24.
//

import SwiftUI
let appBackgroundColor = Color("AppBackgroundColor")

struct WelcomeScreen: View {
    //Navigation Toggle State Variables
    @State var navigateToStudentCreateAccount = false
    @State var navigateToInstructorCreateAccount = false
    
    var body: some View {
        NavigationStack {
            VStack {
                DisplayAppTitleAndIcon()
                AccountSelectionButton(createAccount: $navigateToStudentCreateAccount, accountType: "Student")
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                AccountSelectionButton(createAccount: $navigateToInstructorCreateAccount, accountType: "Instructor")
                    .buttonStyle(.bordered)
                    .foregroundColor(.green)
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

struct DisplayAppTitleAndIcon: View {
    var body: some View {
        Text("Welcome To Teacher's Pet")
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        Image("Welcome Icon")
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .frame(width: 400, height: 400)
            .cornerRadius(5)
        Spacer()
        Text("I am a...")
            .font(.headline)
        Spacer()
            .frame(height: 30)
    }
}

struct AccountSelectionButton: View {
    @Binding var createAccount: Bool
    var accountType: String
    
    var body: some View {
        Button {
            createAccount = true
        } label: {
            Text(accountType)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
        .controlSize(.large)
    }
}
