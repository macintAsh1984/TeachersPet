//
//  InstructorDashboard.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/21/24.
//

import SwiftUI

struct InstructorDashboard: View {
    @Binding var email: String
    @Binding var password: String
    @State var transitionbacktohome = false
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(entity: Instructor.entity(), sortDescriptors: []) var entities: FetchedResults<Instructor>
    
    var body: some View {
        VStack {
            Text("Instructor Dashboard")
            
            Button {
                deleteprofaccount()
            } label: {
                Text("Sign out")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $transitionbacktohome) { // go home if this is trye
            WelcomeScreen()
        }
    }
    
    
    func deleteprofaccount() {
        for entity in entities {
            if (entity.email == email && entity.password == password) {
                managedObjContext.delete(entity)
                DataController().savedata(context: managedObjContext)
                transitionbacktohome = true
            }
        }
    }
    
}

//#Preview {
//    InstructorDashboard()
//}
