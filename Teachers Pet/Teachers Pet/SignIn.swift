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
    @State var navigateToCreateAccount = false
    @State var navigateToInstructorDashboard = false
    @State var showingAlert = false
    @State var alertMessage = ""
    @EnvironmentObject var viewModel:AuthViewModel
//    @Environment(\.managedObjectContext) var managedObjContext
//    @Environment(\.dismiss) var dismiss
//    @FetchRequest(entity: Instructor.entity(), sortDescriptors: []) var entities: FetchedResults<Instructor>
    
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
                TextField("Password", text: $password)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                Spacer()
                    .frame(height: 50)
                Button {
                    
                    if email.isEmpty || password.isEmpty {
                        showingAlert = true
                    } else {
                        Task {
                            do {
                                try await viewModel.signIn(withEmail: email, password: password)
                                navigateToInstructorDashboard = true
                            }catch {
                                print("Error signing in")
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
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
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
            .background(Color("AppBackgroundColor"))
            .navigationDestination(isPresented: $navigateToCreateAccount) {
                CreateAccount()
            }
            .navigationDestination(isPresented: $navigateToInstructorDashboard) { //pass in the email and password entered
                Instructorview()
            }
        }
    }
//    func Checkifemailpasswordisvalid() {
//        for entity in entities { //need to fix bug where if no account has been created, alert must be presented still
//            if (entity.email == email && entity.password == password) {
//                showingAlert = false
//                navigateToInstructorDashboard = true
//            }
//            else {
//                alertMessage = "Not a valid account, please try again"
//                showingAlert = true
//            }
//            
//        }
//        
//    }
}

#Preview {
    SignIn()
}
