//
//  CreateAccount.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/20/24.
//

import SwiftUI

struct CreateAccount: View {
    @State var firstName = String()
    @State var lastName = String()
    @State var email = String()
    @State var password = String()
    
    var body: some View {
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
                //Take the student to the Join Class page or the instructor to the Create Class page.
            } label: {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.large)
            Spacer()
        }
        .padding()
        .preferredColorScheme(.light)
        .background(Color("AppBackgroundColor"))
    }
}

#Preview {
    CreateAccount()
}
