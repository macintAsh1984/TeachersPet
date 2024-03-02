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
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in \(error.localizedDescription)")
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
            let studentQuerySnapshot = try await Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments()
            let professorsQuerySnapshot = try await Firestore.firestore().collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
            
            //Check if a professor with the given join code exists
            guard let professorDocument = professorsQuerySnapshot.documents.first else {
                print("error professors")
                return
            }
            
            guard let studentDocument = studentQuerySnapshot.documents.first else {
                print("error student")
                return
            }
            
            
            guard let coursename = professorDocument.data()["coursename"] as? String else { //pull that professors coursename
                return
            }
            
            guard let joincode = professorDocument.data()["joincode"] as? String else { //pull that joincode
                return
            }
            
            //Associate the student with the professor in the database
            let professorID = professorDocument.documentID
            let professorStudentsReference = Firestore.firestore().collection("users").document(professorID).collection("students")
            
            //Associate the student with the professor in the database
            let studentID = studentDocument.documentID
            let studentsReference = Firestore.firestore().collection("users")
            
            //Check if the student has already joined the class
            let existingStudentDocument = try await professorStudentsReference.document(currentUser).getDocument()
            if existingStudentDocument.exists {
                print("you already joined this class")
                return
            }
            
            let studentDataForProfessor: [String: Any] = [
                            "id": currentUser,
                            "fullname":Name,
                            "email": email,
                            "coursename": coursename,
                            "joincode": joinCode
                        ]
                        try await professorStudentsReference.document(currentUser).setData(studentDataForProfessor)


            let studentData: [String: Any] = [
                            "id": currentUser,
                            "fullname": Name,
                            "email": email,
                            "coursename": coursename,
                            "joincode": joinCode

                        ]
            try await Firestore.firestore().collection("users").document(currentUser).setData(studentData)
            
            
//            //Associate the student with the prof by adding their name to the document
//            let user = User(id: currentUser, fullname: Name, email: email, coursename: coursename, joincode: joinCode) //create our user object, from Model itself
//            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
//            try await professorStudentsReference.document(currentUser).setData(encodedUser) //upload data to fi
            
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
            
            let user = User(id: currentUser, fullname: Name, email: email, coursename: coursename, joincode: joinCode) //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            try await professorStudentsReference.document(currentUser).setData(encodedUser) //upload data to firebase
            
            await fetchUser()
            
            
        } catch {
            print("error")
        }
    }
    
    // Prototype OH Line Implementation
    func addStudentToLine(joinCode: String, email: String) async throws {
        guard let currentUser = self.userSession?.uid else {
            print("user does not exist")
            return
        }
        do {
            let professorQuerySnapshot = try await Firestore.firestore().collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
            
            //Fetches professor document.
            guard let professorDocument = professorQuerySnapshot.documents.first else {
                print("Professor not found")
                return
            }
            
            
            //Creates Office Hours collection in Firebase.
            let professorID = professorDocument.documentID
            let professorStudentReference = Firestore.firestore().collection("users").document(professorID).collection("Office Hours")
            
            //Checks if student is already in the office hours line.
            let existingProfessorDocument = try await professorStudentReference.document(currentUser).getDocument()
            if existingProfessorDocument.exists {
                print("You are already in line.")
                return
            }
            
            let user = User(id: currentUser, fullname: "", email: email, coursename: "", joincode: "") //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            
            //Upload office hours line (with student) into Firebase.
            try await professorStudentReference.document(currentUser).setData(encodedUser)
            
            await fetchUser()
            
            
        } catch {
            print("error")
        }
        
    }
    
    //To be implemented.
    func removeStudentFromLine() {
        
    }
    
}
