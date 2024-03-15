//
//  SignIn.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/22/24.
//

import SwiftUI

struct SignIn: View {
    //User Account Information State Variables
    @State var email = String()
    @State var password = String()
    @State var joinCode = String()
    
    //Account Type Toggle Bindings
    @Binding var isStudent: Bool
    @Binding var isInstructor: Bool
    
    //Navigation Toggle State Variables
    @State var navigateToStudentDashboard = false
    @State var navigateToInstructorDashboard = false
    @State var navigateToCreateAccount = false
    
    //Alert Toggle State Variables
    @State var displayAlert = false
    @State var invalidSignInInfo = false
    
    //Error Messages
    let emptyFieldsErrMessage = "Please fill in all fields to sign in."
    @State var invalidSignInErrMessage = String()
    
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                SignInPageTitle()
                SignInTextFields(email: $email, password: $password)
                Spacer()
                    .frame(height: 50)
                
                Button {
                    signUserIntoAccount()
                } label: {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.large)
                Spacer()
                    .frame(height: 40)
                CreateAccountButton(createAccount: $navigateToCreateAccount)
                Spacer()
                
            }
            .padding()
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden()
            .background(appBackgroundColor)
            .navigationDestination(isPresented: $navigateToCreateAccount) {
                CreateAccount(isStudent: $isStudent, instructorView: $isInstructor)
            }
            .navigationDestination(isPresented: $navigateToInstructorDashboard) {
                InstructorDashboard()
            }
            .navigationDestination(isPresented: $navigateToStudentDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
            .alert(emptyFieldsErrMessage, isPresented: $displayAlert) {
                Button(role: .cancel) {} label: {Text("OK")}
            }
            .alert(isPresented: $invalidSignInInfo) {
                Alert(title: Text("Could Not Sign In"), message: Text(invalidSignInErrMessage), dismissButton: .cancel(Text("OK")))
            }
        }
    }
    
    func signUserIntoAccount() {
        if email.isEmpty || password.isEmpty {
            displayAlert = true
        } else {
            Task {
                do {
                    if isStudent {
                        try await viewModel.signInforStudents(withEmail: email, password: password)
                        joinCode = viewModel.currentUser?.joincode ?? ""
                        navigateToStudentDashboard = true
                    } else {
                        try await viewModel.signIn(withEmail: email, password: password)
                        joinCode = viewModel.currentUser?.joincode ?? ""
                        navigateToInstructorDashboard = true
                    }
                } catch {
                    invalidSignInInfo = true
                    invalidSignInErrMessage = error.localizedDescription
                }
            }
        }
    }

}

struct SignInPageTitle: View {
    var body: some View {
        Text("Welcome Back")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        Spacer()
            .frame(height: 10)
        Text("Sign In To Your Account")
            .font(.title2)
            .fontWeight(.regular)
        Spacer()
            .frame(height: 40)
    }
}

struct SignInTextFields: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
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

struct CreateAccountButton: View {
    @Binding var createAccount: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text("Don't have an account?")
            Button {
                createAccount = true
            } label: {
                Text("Join Now")
                    .underline()
                    .foregroundStyle(.green)
            }
        }
    }
}

//#Preview {
//    SignIn()
//}
