//
//  Instructorview.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/22/24.
//

import SwiftUI
import CoreData
 //for now, inject the current user data into this view
struct Instructorview: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    VStack {
                        Text(user.fullname)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text(user.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text(user.coursename)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text(user.joincode)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            
                    }
                    Button {
                        Task {
                            viewModel.signout()
                        }
                    } label: {
                        Text("Sign out")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

