//
//  SignIn.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/22/24.
//

import SwiftUI

struct SignIn: View {
    @State var email = String()
    @State var password = String()
    @State var joinCode = String()
    @State var navigateToCreateAccount = false
    
    @Binding var isStudent: Bool
    @Binding var isInstructor: Bool
    @State var navigateToStudentDashboard = false
    @State var navigateToInstructorDashboard = false
    
    @State var showingAlert = false
    @State var invalidSignInInfo = false
    
    let emptyFieldsErrMessage = "Please fill in all fields to sign in."
    @State var invalidSignInErrMessage = String()
    
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(height: 20)
                Text("Please sign in.")
                    .font(.title2)
                    .fontWeight(.regular)
                Spacer()
                    .frame(height: 30)
                
                TextField("Email", text: $email)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                Spacer()
                    .frame(height: 50)
                Button {
                    if email.isEmpty || password.isEmpty {
                        showingAlert = true
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
                } label: {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .controlSize(.large)
                Spacer()
                
                HStack(spacing: 5) {
                    Text("Don't have an account?")
                    Button {
                        navigateToCreateAccount = true
                    } label: {
                        Text("Join Now")
                            .underline()
                            .foregroundStyle(.orange)
                    }
    
                }
                
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
            .alert(emptyFieldsErrMessage, isPresented: $showingAlert) {
                Button(role: .cancel) {} label: {Text("OK")}
            }
            .alert(isPresented: $invalidSignInInfo) {
                Alert(title: Text("Could Not Sign In"), message: Text(invalidSignInErrMessage), dismissButton: .cancel(Text("OK")))
            }
        }
    }

}

//#Preview {
//    SignIn()
//}
