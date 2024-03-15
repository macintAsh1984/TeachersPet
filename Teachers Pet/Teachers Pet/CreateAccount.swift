//
//  CreateAccount.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/20/24.
//

import SwiftUI

struct CreateAccount: View {
    //Bindings used to determine if new user is a student or instructor.
    @Binding var isStudent: Bool
    @Binding var instructorView: Bool
    
    //User Account Information State Variables
    @State var firstName = String()
    @State var lastName = String()
    @State var email = String()
    @State var password = String()
    
    //Navigation Toggle State Variables
    @State var showingInstructorView = false
    @State var navigatetoStudentJoinClass = false
    @State var navigateToCreateClass = false
    @State var navigateToStudentSignIn = false
    @State var navigateToInstructorSignIn = false
    
    @State var showAlert = false
    let alertMessage = "Error, please fill in all the information"
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Create An Account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(height: 40)
                EnterAccountInfo(firstName: $firstName, lastName: $lastName, email: $email, password: $password)
                Spacer()
                    .frame(height: 50)
                
                Button {
                    createAccount()
                } label: {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.large)
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK") { }
                }
                Spacer()
                    .frame(height: 20)
                
                SignInButton(isStudent: $isStudent, studentSignIn: $navigateToStudentSignIn, instructorSignIn: $navigateToInstructorSignIn)
                Spacer()
            }
            .padding()
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
            .navigationDestination(isPresented: $navigateToCreateClass) {
                CreateClass(email: $email, password: $password, Name: $firstName)
            }
            .navigationDestination(isPresented: $navigateToInstructorSignIn) {
                SignIn(isStudent: $navigateToStudentSignIn, isInstructor: $instructorView)
            }
            .navigationDestination(isPresented: $navigatetoStudentJoinClass) {
                StudentJoinClass(email: $email, name: $firstName, password: $password)
            }
        }
    }
    
    func createAccount() {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
            showAlert = true
        } else if isStudent {
            navigatetoStudentJoinClass = true
        } else {
            navigateToCreateClass = true
        }
    }
}

struct EnterAccountInfo: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
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
            .disableAutocorrection(true)
        #if os(iOS)
            .autocapitalization(.none)
        #endif
        SecureField("Password", text: $password)
            .padding(.all)
            .background()
            .cornerRadius(10.0)
            .disableAutocorrection(true)
        #if os(iOS)
            .autocapitalization(.none)
        #endif
    }
}


struct SignInButton: View {
    @Binding var isStudent: Bool
    @Binding var studentSignIn: Bool
    @Binding var instructorSignIn: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text("Already have an account?")
            Button {
                if isStudent {
                    studentSignIn = true
                }
                instructorSignIn = true
            } label: {
                Text("Sign In")
                    .underline()
                    .foregroundStyle(.green)
            }

        }
    }
}
