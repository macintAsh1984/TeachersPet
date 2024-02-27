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
    @State var deleteAccountAlert = false
//    @Environment(\.managedObjectContext) var managedObjContext
//    @Environment(\.dismiss) var dismiss
//    @FetchRequest(entity: Instructor.entity(), sortDescriptors: []) var entities: FetchedResults<Instructor>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                Text("Office Hours")
//                Button {
//                    deleteprofaccount()
//                } label: {
//                    Text("Sign out")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.red)
//                        .frame(maxWidth: .infinity)
//                }
            }
            .padding()
            .preferredColorScheme(.light)
            .background(Color("AppBackgroundColor"))
            
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $transitionbacktohome) { // go home if this is trye
                WelcomeScreen()
            }
            .navigationTitle("Dashboard")
            #if(ios)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem {
                    Menu() {
                        Button() {
                            //Add Class logic
                        } label: {
                            Label("Add Another Class", systemImage: "plus")
                        }
                        
                        Button() {
                            //Set up office hours logic
                        } label: {
                            Label("Set Up Office Hours", systemImage: "studentdesk")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            deleteAccountAlert = true
                        } label: {
                            Label("Delete Account", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert (isPresented: $deleteAccountAlert) {
                Alert(
                    title: Text("Are you sure you want to delete your account?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete Account")) {
                        //deleteprofaccount()
                    },
                    secondaryButton: .cancel()
                
                )
            }
        }
    }
    
    
//    func deleteprofaccount() {
//        for entity in entities {
//            if (entity.email == email && entity.password == password) {
//                managedObjContext.delete(entity)
//                DataController().savedata(context: managedObjContext)
//                transitionbacktohome = true
//            }
//        }
//    }
    
}

struct Sidebar: View {
    var body: some View {
        List {
            Text("Row")
        }
        .listStyle(SidebarListStyle())
    }
}


#Preview {
    InstructorDashboard(email: .constant(""), password: .constant(""))
}
