//
//  Instructorview.swift
//  Teachers Pet
//
//  Created by Sukhpreet Aulakh on 2/22/24.
//

import SwiftUI
import CoreData

struct Instructorview: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(entity: Instructor.entity(), sortDescriptors: []) var entities: FetchedResults<Instructor>
    var body: some View {
        List {
                    ForEach(entities, id: \.self) { entity in
                        VStack(alignment: .leading) {
                            Text("Name: \(entity.firstname ?? "")")
                            Text("Email: \(entity.email ?? "")")
                            Text("Password: \(entity.password ?? "")")
                            Text("Lastname: \(entity.lastname ?? "")")
                        }
                    }
                }
    }
}

#Preview {
    Instructorview()
}
