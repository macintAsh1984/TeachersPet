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
                CreateClassButton(navigateToCodeGeneration: $navigateToCodeGeneration, courseName: $courseName, noCourseNameAlert: $noCourseNameAlert)
                Spacer()
                    .frame(height: 40)
                JoinClassPageButton(navigateToJoinClass: $navigateToJoinClass)
                Spacer()
            }
            .padding()
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
            .alert(isPresented: $noCourseNameAlert) {
                Alert(title: Text("Invalid Course Name"), message: Text("Please Enter A Course Name"), dismissButton: .cancel(Text("OK")))
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
    @Binding var navigateToCodeGeneration: Bool
    @Binding var courseName: String
    @Binding var noCourseNameAlert: Bool
    
    var body: some View {
        Button {
            if courseName.isEmpty {
                noCourseNameAlert = true
            } else {
                navigateToCodeGeneration = true
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


//#Preview {
//    CreateClass()
//}
