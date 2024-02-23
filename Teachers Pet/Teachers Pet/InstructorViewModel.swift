//
//  InstructorViewModel.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/21/24.
//

import SwiftUI

@MainActor class InstructorViewModel: ObservableObject {
    
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    func saveuserinfo(firstname: String, lastname: String, email: String, password: String) {
        //use coredata here to save user information
    }
    
    
}
