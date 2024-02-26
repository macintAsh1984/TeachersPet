//
//  User.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/25/24.
//

import Foundation

struct User: Identifiable, Codable { //to add properties like fullname, phonenumber, etc codable protocol, allows us to take incoming raw data or json data and map it into a data object, known as decoding
    let id: String
    let fullname: String
    let email: String
    let coursename: String
    let joincode: String
    
    var intitials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

//extension User {
//    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Sam King", email: "Test@gmail.com")
//}
