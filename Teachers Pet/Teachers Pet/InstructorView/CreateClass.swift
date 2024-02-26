//
//  CreateClass.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/21/24.
//

import SwiftUI

struct CreateClass: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var courseName = String()
    @State var navigateToCodeGeneration = false
    @Binding var email: String
    @Binding var password: String
    @Binding var Name: String

    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text("Create A Class")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Enter Course Name")
                    .font(.title2)
                    .fontWeight(.semibold)
                TextField("Course Name", text: $courseName)
                    .padding(.all)
                    .background()
                    .cornerRadius(10.0)
                Spacer()
                Button {
                    navigateToCodeGeneration = true
                } label: {
                    Text("Create Class")
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
            .navigationDestination(isPresented: $navigateToCodeGeneration) {
                ClassJoinCodeGeneration(email: $email, password: $password, Name: $Name, coursename: $courseName)
            }
        }
        
    }
}

//#Preview {
//    CreateClass()
//}
