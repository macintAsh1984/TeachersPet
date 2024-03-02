//
//  CreateAccount.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/20/24.
//

import SwiftUI

struct CreateAccount: View {
    @Binding var studentview: Bool
    @Binding var instructorView: Bool
    @State var firstName = String()
    @State var lastName = String()
    @State var email = String()
    @State var password = String()
    @State var showingInstructorView = false
    @State var showingAlert = false
    @State var alertMessage = ""
    @State var navigatetoStudentplace = false
    
    @State var navigateToCreateClass = false
    @State var navigateToStudentSignIn = false
    @State var navigateToSignIn = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create An Account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                TextField("First Name", text: $firstName)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                TextField("Last Name", text: $lastName)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                TextField("Email", text: $email)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                TextField("Password", text: $password)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                
                Spacer()
                
                Button {
                    if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
                        showingAlert = true
                    } else if studentview == true {
                        Task {
                            try await viewModel.createUser(withEmail: email, password: password, fullname: firstName, coursename: "", joincode: "")
                        }
                        navigatetoStudentplace = true
                    } else {
                        navigateToCreateClass = true
                    }

                } label: {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .controlSize(.large)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error, please fill in all the information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                Spacer()
                    .frame(height: 20)
                HStack(spacing: 5) {
                    Text("Already have an account?")
                    Button {
                        if studentview {
                            navigateToStudentSignIn = true
                        }
                        navigateToSignIn = true
                    } label: {
                        Text("Sign In")
                            .underline()
                            .foregroundStyle(.orange)
                    }
    
                }
                Spacer()
        
            }
            .padding()
            .preferredColorScheme(.light)
            .background(Color("AppBackgroundColor"))

            .navigationDestination(isPresented: $navigateToCreateClass) {
                CreateClass(email: $email, password: $password, Name: $firstName)
            }
            .navigationDestination(isPresented: $navigateToSignIn) {
                SignIn(isStudent: $navigateToStudentSignIn)
            }
            
            .navigationDestination(isPresented: $navigatetoStudentplace) {
                StudentJoinClass(email: email, Name: firstName)
            }
        }
    }
}
