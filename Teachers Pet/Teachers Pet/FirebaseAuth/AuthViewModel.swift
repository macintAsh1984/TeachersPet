//
//  AuthViewModel.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/25/24.
//

//This file will be responsible for having all functionality to updating the backend with user
//for instance, email and password.

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFirestoreSwift


@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, coursename: String, joincode: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //create user using firebase code that we installed
            self.userSession = result.user //if we get successful result back
            let user = User(id: result.user.uid, fullname: fullname, email: email, coursename: coursename, joincode: joincode) //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //upload data to firestore
            await fetchUser()
        } catch {
            print("Failed to create user \(error.localizedDescription)")
        }
    }
    
    func createStudentUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //create user using firebase code that we installed
            self.userSession = result.user //if we get successful result back
            let user = StudentUser(id: result.user.uid, fullname: fullname, email: email) //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //upload data to firestore
            await fetchUser()
        } catch {
            print("Failed to create user \(error.localizedDescription)")
        }
    }
    
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out")
        }
    }
    
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("Current user is \(self.currentUser)")
        
    }
    
    func joinClassAsStudent(joinCode: String, Name: String, email: String) async throws {
        guard let currentUser = self.userSession?.uid else {
            print("user does not exist")
            return
        }
        do {
            let professorsQuerySnapshot = try await Firestore.firestore().collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
            
            //Check if a professor with the given join code exists
            guard let professorDocument = professorsQuerySnapshot.documents.first else {
                print("error")
                return
            }
            
            
            guard let coursename = professorDocument.data()["coursename"] as? String else { //pull that professors coursename
                return
            }
            
            //Associate the student with the professor in the database
            let professorID = professorDocument.documentID
            let professorStudentsReference = Firestore.firestore().collection("users").document(professorID).collection("students")
            
            //Check if the student has already joined the class
            let existingStudentDocument = try await professorStudentsReference.document(currentUser).getDocument()
            if existingStudentDocument.exists {
                print("you already joined this class")
                return
            }
            
    
            //Associate the student with the prof by adding their name to the document
            let user = User(id: currentUser, fullname: Name, email: email, coursename: coursename, joincode: joinCode) //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            try await professorStudentsReference.document(currentUser).setData(encodedUser) //upload data to fi
            
            await fetchUser()
            
            
        } catch {
            print("error")
        }
    }
    
    
    func joinClassAsTA(joinCode: String, Name: String, email: String) async throws {
        guard let currentUser = self.userSession?.uid else {
            print("user does not exist")
            return
        }
        do {
            let professorsQuerySnapshot = try await Firestore.firestore().collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
            
            //Check if a professor with the given join code exists
            guard let professorDocument = professorsQuerySnapshot.documents.first else {
                print("Professor not found")
                return
            }
            
            
            guard let coursename = professorDocument.data()["coursename"] as? String else { //pull that professors coursename
                return
            }
            
            //Associate the student with the professor in the database
            let professorID = professorDocument.documentID
            let professorStudentsReference = Firestore.firestore().collection("users").document(professorID).collection("TAs")
            
            //Check if the student has already joined the class
            let existingStudentDocument = try await professorStudentsReference.document(currentUser).getDocument()
            if existingStudentDocument.exists {
                print("you already joined this class")
                return
            }
            
    
            //Associate the student with the prof by adding their name to the document
//            let taData: [String: Any] = [
//                            "id": currentUser,
//                            "fullname": Name,
//                            "email": email,
//                            "coursename": coursename,
//
//                        ]
//            
//            try await professorStudentsReference.document(currentUser).setData(taData)
            
            
            let user = User(id: currentUser, fullname: Name, email: email, coursename: coursename, joincode: joinCode) //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            try await professorStudentsReference.document(currentUser).setData(encodedUser) //upload data to firebase
            
            await fetchUser()
            
            
        } catch {
            print("error")
        }
    }

    
}

