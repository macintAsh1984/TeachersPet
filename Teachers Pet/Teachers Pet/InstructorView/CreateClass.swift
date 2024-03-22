//
//  CreateClass.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/21/24.
//

import SwiftUI

struct CreateClass: View {
    //User Account Info Binding/State Variables
    @Binding var email: String
    @Binding var password: String
    @Binding var Name: String
    @State var courseName = String()
    
    //Navigation Toggle State Variables
    @State var navigateToCodeGeneration = false
    @State var navigateToJoinClass = false
    @State var noCourseNameAlert = false
    @State var alertMessage = ""
    @State var alertTitle = ""
    @State var navigatetoInstructorSignIn = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                CreateClassPageTitle()
                TextField("Course Name", text: $courseName)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                Spacer()
                    .frame(height: 40)
                CreateClassButton(navigateToCodeGeneration: $navigateToCodeGeneration, courseName: $courseName, noCourseNameAlert: $noCourseNameAlert, email: $email, alertMessage: $alertMessage, alertTitle: $alertTitle)
                Spacer()
                    .frame(height: 40)
                JoinClassPageButton(navigateToJoinClass: $navigateToJoinClass)
                Spacer()
            }
            .padding()
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
            
            .alert(isPresented: $noCourseNameAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton:  .default(Text("Sign In"), action: {
                        navigatetoInstructorSignIn = true
                    }),
                    secondaryButton: .default(Text("OK"))
                )
            }
            
            .navigationDestination(isPresented: $navigatetoInstructorSignIn) {
                SignIn(isStudent: .constant(false), isInstructor: .constant(true))
            }
            
            .navigationDestination(isPresented: $navigateToCodeGeneration) {
                ClassJoinCodeGeneration(email: $email, password: $password, Name: $Name, coursename: $courseName)
            }
            .navigationDestination(isPresented: $navigateToJoinClass) {
                InstructorJoinClass(email: $email, password: $password, name: $Name)
            }
        }
        
    }
}

struct CreateClassPageTitle: View {
    var body: some View {
        Text("Create A Class")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        Spacer()
            .frame(height: 60)
        Text("Enter Course Name")
            .font(.title2)
            .fontWeight(.medium)
    }
}

struct CreateClassButton: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var navigateToCodeGeneration: Bool
    @Binding var courseName: String
    @Binding var noCourseNameAlert: Bool
    @Binding var email: String
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
        Button {
            if courseName.isEmpty {
                noCourseNameAlert = true
                alertMessage = "Please enter a course name"
            } else {
                checkIfInstructorcanbemade()
            }
        } label: {
            Text("Create Class")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .controlSize(.large)
    }
    
    func checkIfInstructorcanbemade() {
        Task {
            do {
                let emaildoesNotexist = try await viewModel.canCreateInstructor(withEmail: email)
                if !emaildoesNotexist {
                    noCourseNameAlert = true
                    alertTitle = "Incorrect."
                    alertMessage = "Account with email already exists."
                } else {
                    navigateToCodeGeneration = true
                }
            } catch {
                noCourseNameAlert = true
                alertMessage = "Account with email already exists"
            }
            
        }
    }
}

struct JoinClassPageButton: View {
    @Binding var navigateToJoinClass: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text("Have a class join code?")
            Button {
                navigateToJoinClass = true
            } label: {
                Text("Join Your Class")
                    .underline()
                    .foregroundStyle(.green)
            }

        }
    }
}
