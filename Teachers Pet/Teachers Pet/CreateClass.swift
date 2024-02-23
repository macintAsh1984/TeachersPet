//
//  CreateClass.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/21/24.
//

import SwiftUI

struct CreateClass: View {
    @State var courseName = String()
    @State var navigateToCodeGeneration = false
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
                    //Save Course name to disk and create class
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
                ClassJoinCodeGeneration(courseName: courseName)
            }
        }
        
    }
}

#Preview {
    CreateClass()
}
