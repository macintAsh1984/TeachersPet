//
//  DataController.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/21/24.
//

import Foundation
import CoreData

@MainActor class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "InstructorM") //make sure this is the same label as CoreData
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    
    func savedata(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data is successfully saved")
        } catch {
            print ("Cannot save data")
        }
    }
    
    
    func addinstructorinformation(firstname: String, lastname: String, email: String, password: String, context: NSManagedObjectContext) {
        let name = Instructor(context: context)
        name.firstname = firstname
        name.lastname = lastname
        name.email = email
        name.password = password
        
        savedata(context: context)
        
    }
    
    func Editinstructorinformation(name: Instructor, firstname: String, lastname: String, email: String, password: String, context: NSManagedObjectContext) {
        name.firstname = firstname
        name.lastname = lastname
        name.email = email
        name.password = password
        
        savedata(context: context)
        
    }
    
    
    func saveCourseName(courseName: String, context: NSManagedObjectContext) {
        let course = Instructor(context: context)
        course.coursename = courseName
        
        savedata(context: context)
        
    }
    
    func saveJoinCode(joinCode: String, context: NSManagedObjectContext) {
        let course = Instructor(context: context)
        course.joincode = joinCode
        
        savedata(context: context)
        
    }
    
    
}

