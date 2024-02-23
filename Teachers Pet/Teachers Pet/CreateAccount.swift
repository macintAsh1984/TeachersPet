//
//  CreateAccount.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/20/24.
//

import SwiftUI

struct CreateAccount: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var firstName = String()
    @State var lastName = String()
    @State var email = String()
    @State var password = String()
    @State var showingInstructorView = false
    @State var showingAlert = false
    @State var alertMessage = ""
    @State var navigateToCreateClass = false
    
    var body: some View {
        //Save name or should we just go to next view
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
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty {
                        DataController().addinstructorinformation(firstname: firstName, lastname: lastName, email: email, password: password, context: managedObjContext)
                        
                        //showingInstructorView = true
                        navigateToCreateClass = true
                    } else {
                        alertMessage = "Please enter all information"
                        showingAlert = true
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
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                
                
                
                Spacer()
            }
            .padding()
            .preferredColorScheme(.light)
            .background(Color("AppBackgroundColor"))
//            .fullScreenCover(isPresented: $showingInstructorView) {
//                Instructorview()
//            }
            .navigationDestination(isPresented: $navigateToCreateClass) {
                CreateClass()
            }
        }
    }
}

#Preview {
    CreateAccount()
}
