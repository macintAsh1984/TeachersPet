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
    @Published var positionInLine: Int = 1
    @Published var coursename: String = ""
    
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    let db = Firestore.firestore()
    
    
    //Methods for signing in and out of accounts.
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
    
    //Methods for fetching users.
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else {return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("Current user is \(self.currentUser)")
        
    }
    
    //Test Method For Allowing Signed In Students To Join The Office Hours Line.
    func fetchStudentUserInfo() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            do {
                // Query the users collection to find all teacher documents
                let teacherQuerySnapshot = try await db.collection("users").getDocuments()
                
                // Iterate through the teacher documents
                for teacherDocument in teacherQuerySnapshot.documents {
                    // Get the reference to the student document within the teacher's students subcollection
                    let studentDocumentRef = teacherDocument.reference.collection("students").document(uid)
                    
                    // Fetch the student document
                    let studentDocumentSnapshot = try await studentDocumentRef.getDocument()
                    
                    // Check if the student document exists and matches the provided UID
                    if let _ = studentDocumentSnapshot.data(), studentDocumentSnapshot.exists {
                        // This teacher document contains the student with the provided UID
                        self.currentUser = try? studentDocumentSnapshot.data(as: User.self)
                        print("Teacher document found for student with UID \(uid): \(teacherDocument.data())")
                    }
                }
            } catch {
                print("Error fetching teacher documents: \(error.localizedDescription)")
            }
        }

    
    func fetchTeacherDocumentsForStudent() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            do {
                // Query the users collection to find all teacher documents
                let teacherQuerySnapshot = try await db.collection("users").getDocuments()
                
                // Iterate through the teacher documents
                for teacherDocument in teacherQuerySnapshot.documents {
                    // Get the reference to the student document within the teacher's students subcollection
                    let studentDocumentRef = teacherDocument.reference.collection("students").document(uid)
                    
                    // Fetch the student document
                    let studentDocumentSnapshot = try await studentDocumentRef.getDocument()
                    
                    // Check if the student document exists and matches the provided UID
                    if let studentData = studentDocumentSnapshot.data(), studentDocumentSnapshot.exists {
                        // This teacher document contains the student with the provided UID
                        print("Teacher document found for student with UID \(uid): \(teacherDocument.data())")
                    }
                }
            } catch {
                print("Error fetching teacher documents: \(error.localizedDescription)")
            }
        }
    
    func getCourseName() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            // Query the users collection to find all teacher documents
            let teacherQuerySnapshot = try await Firestore.firestore().collection("users").getDocuments()
            
            // Iterate through the teacher documents
            for teacherDocument in teacherQuerySnapshot.documents {
                // Get the reference to the student document within the teacher's students subcollection
                let studentDocumentRef = teacherDocument.reference.collection("students").document(uid)
                
                // Fetch the student document
                let studentDocumentSnapshot = try await studentDocumentRef.getDocument()
                
                // Check if the student document exists and matches the provided UID
                if let _ = studentDocumentSnapshot.data(), studentDocumentSnapshot.exists {
                    // This teacher document contains the student with the provided UID
                    print("Teacher document found for student with UID \(uid): \(teacherDocument.data())")
                    let data = teacherDocument.data()
                    if let coursenameTemp = data["coursename"] as? String {
                        // If coursename is not nil, print its value
                        self.coursename = coursenameTemp
                    } else {
                        // If coursename is nil or not a String, print a message or handle the case accordingly
                        print("coursename is nil or not a String")
                    }
                }
            }
        } catch {
            print("Error fetching teacher documents: \(error.localizedDescription)")
        }
        
    }

    func fetchTeacherDocumentsForTA() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            do {
                // Query the users collection to find all teacher documents
                let teacherQuerySnapshot = try await db.collection("users").getDocuments()
                
                // Iterate through the teacher documents
                for teacherDocument in teacherQuerySnapshot.documents {
                    // Get the reference to the student document within the teacher's TA subcollection
                    let TADocRef = teacherDocument.reference.collection("TAs").document(uid)
                    
                    // Fetch the TA document
                    let TADocumentSnapshot = try await TADocRef.getDocument()
                    
                    // Check if the TA document exists and matches the provided UID
                    if let studentData = TADocumentSnapshot.data(), TADocumentSnapshot.exists {
                        // This teacher document contains the student with the provided UID
                        print("Teacher document found for TA with UID \(uid): \(teacherDocument.data())")
                    }
                }
            } catch {
                print("Error fetching teacher documents: \(error.localizedDescription)")
            }
        }
    
    //Methods for creating users (main instructors, TAs, and students).
    func createUser(withEmail email: String, password: String, fullname: String, coursename: String, joincode: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //create user using firebase code that we installed
            self.userSession = result.user //if we get successful result back
            let user = User(id: result.user.uid, fullname: fullname, email: email, coursename: coursename, joincode: joincode) //create our user object, from Model itself
            let encodedUser = try Firestore.Encoder().encode(user) //encode that object through the encodable protocol, encodes into JSON data so that it can be stored into firebase
            try await db.collection("users").document(user.id).setData(encodedUser) //upload data to firestore
            await fetchUser()
        } catch {
            print("Failed to create user \(error.localizedDescription)")
        }
    }
    
    func createStudent(withEmail email: String, password: String, fullname: String, coursename: String, joincode: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Find the teacher document using the joincode
            let teacherQuerySnapshot = try await db.collection("users").whereField("joincode", isEqualTo: joincode).getDocuments()
            
            guard let teacherDocument = teacherQuerySnapshot.documents.first else {
                print("Teacher with joincode \(joincode) not found")
                return
            }
            
            // Create the student user under the teacher's collection
            let user = User(id: result.user.uid, fullname: fullname, email: email, coursename: coursename, joincode: joincode)
            let encodedUser = try Firestore.Encoder().encode(user)
            let teacherID = teacherDocument.documentID
            try await db.collection("users").document(teacherID).collection("students").document(user.id).setData(encodedUser)
            
            await fetchTeacherDocumentsForStudent()
            
        } catch {
            print("Failed to create student user: \(error.localizedDescription)")
        }
    }
    
    func createTA(withEmail email: String, password: String, fullname: String, joincode: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Find the teacher document using the joincode
            let teacherQuerySnapshot = try await db.collection("users").whereField("joincode", isEqualTo: joincode).getDocuments()
            
            guard let instructorDocument = teacherQuerySnapshot.documents.first else {
                print("Teacher with joincode \(joincode) not found")
                return
            }
            
            let instructorData = instructorDocument.data()
            guard let courseName = instructorData["coursename"] as? String else {
                print("No Coursename found")
                return
            }
            
            // Create the student user under the teacher's collection
            let user = User(id: result.user.uid, fullname: fullname, email: email, coursename: courseName, joincode: "")
            let encodedUser = try Firestore.Encoder().encode(user)
            let instructorID = instructorDocument.documentID
            try await db.collection("users").document(instructorID).collection("TAs").document(user.id).setData(encodedUser)
            
            await fetchTeacherDocumentsForTA()
            
        } catch {
            print("Failed to create TA user: \(error.localizedDescription)")
        }
    }

    func addStudentToLine(joinCode: String, email: String) async throws {
        guard let currentUser = self.userSession?.uid else {
            print("user does not exist")
            return
        }
        
        do {
           //Retrieve the instructor document with the same join code.
            let professorQuerySnapshot = try await db.collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
            
            // Users -> UID -> Students
            //Fetches the instructor with the corresponding join code.
            guard let professorDocument = professorQuerySnapshot.documents.first else {
                print("Professor not found")
                return
            }
            
            //Retrieve the ID of the instructor document
            let professorID = professorDocument.documentID
            
            //Get all of the students in the instructor's course.
            let studentsInCourse = try await db.collection("users").document(professorID).collection("students").getDocuments()
            
            //For all the students under the instructor, get their data (name, email, etc.). Then check if the logged in student's ID in Firebase is the same ID that is under the instructor. If they match, add that student to the Office Hours collection.
            for studentDocument in studentsInCourse.documents {
                let studentData = studentDocument.data()
                
                if studentData["id"] as? String == currentUser {
                   try await db.collection("users").document(professorID).collection("Office Hours").addDocument(data: studentData)
                }
            }
            
            await fetchTeacherDocumentsForStudent()
            
            
        } catch {
            print("error")
        }
        
    }
    
    //Methods related to managing the office hours line.
    func calculateLinePosition(joinCode: String, email: String) async throws {
        guard let currentUser = self.userSession?.uid else {
            print("user does not exist")
            return
        }
        do {
            //Retrieve the instructor document with the same join code.
             let professorQuerySnapshot = try await db.collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
             
             // Users -> UID -> Students
             //Fetches the instructor with the corresponding join code.
             guard let professorDocument = professorQuerySnapshot.documents.first else {
                 print("Professor not found")
                 return
             }
             
             //Retrieve the ID of the instructor document
             let professorID = professorDocument.documentID
             
             //Get all of the students in the instructor's course.
             let studentsInCourse = try await db.collection("users").document(professorID).collection("Office Hours").getDocuments()
             
             //For all the students under the instructor, get their data (name, email, etc.). Then check if the logged in student's ID in Firebase is the same ID that is under the instructor. If they match, exit the loop and return the student's position in line.
             for studentDocument in studentsInCourse.documents {
                 let studentData = studentDocument.data()
                 
                 if studentData["id"] as? String == currentUser {
                     return
                 } else {
                     positionInLine += 1
                 }
             }
        
            }
    
        }
    
    //To be implemented.
     func removeStudentFromLine(joinCode: String, email: String) async throws {
         guard let currentUser = self.userSession?.uid else {
             print("user does not exist")
             return
       }
       
       do {
           // Retrieve the instructor document with the same join code.
           let professorQuerySnapshot = try await Firestore.firestore().collection("users").whereField("joincode", isEqualTo: joinCode).getDocuments()
           
           // Users -> UID -> Students
           // Fetches the instructor with the corresponding join code.
           guard let professorDocument = professorQuerySnapshot.documents.first else {
               print("Professor not found")
               return
           }
           
           // Retrieve the ID of the instructor document
           let professorID = professorDocument.documentID
           
           // Get the reference to the student's document in the "Office Hours" collection
           let studentDocumentReference = Firestore.firestore().collection("users").document(professorID).collection("Office Hours").document(currentUser)
           
           do {
               //get all the documents with userID in office hours
               let studentQuerySnapshot = try await Firestore.firestore().collection("users").document(professorID).collection("Office Hours").whereField("id", isEqualTo: studentDocumentReference.documentID).getDocuments()
               
               
               //Removing the student
               for document in studentQuerySnapshot.documents {
                   try await document.reference.delete()
                   print("Document \(document.documentID) deleted successfully.")
               }
           } catch {
               print("Error deleting documents: \(error)")
           }
           
       } catch {
           print("error: \(error)")
       }
   }
    
    
    
}//end of class

