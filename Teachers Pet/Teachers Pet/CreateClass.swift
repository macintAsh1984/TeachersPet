//
//  CreateClass.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/21/24.
//

import SwiftUI

struct CreateClass: View {
    @State var courseName = String()
    var body: some View {
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
                //Generate a join code and a QR code with the join code
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
        
    }
}

#Preview {
    CreateClass()
}
