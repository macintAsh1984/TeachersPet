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
                    navigateToInstructorDashboard = true
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
            .background(Color("AppBackgroundColor"))
            .navigationDestination(isPresented: $navigateToCreateAccount) {
                CreateAccount()
            }
            .navigationDestination(isPresented: $navigateToInstructorDashboard) {
                InstructorDashboard()
            }
        }
    }
}

#Preview {
    SignIn()
}
