
import SwiftUI

struct OHLineManagement: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var students: [String] = [] // Use @State to manage the list of students
    @Binding var joinCode:String
    @State var showingEndOHAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if viewModel.allStudentsinoh.isEmpty {
                        Text("No one in queue")
                            .foregroundStyle(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.allStudentsinoh, id: \.self.fullname) { student in
                            StudentEntry(studentName: student.fullname, joinCode: $joinCode)
                        }
                            
                                .onDelete { indexSet in
                                    Task {
                                        do {
                                            for index in indexSet {
                                                let student = viewModel.allStudentsinoh[index]
                                                let uid = student.uid
                                            
                                                try await viewModel.removeStudentFromLineInstructor(joinCode: joinCode, UID: uid)
                                            }
                                            viewModel.allStudentsinoh.remove(atOffsets: indexSet)
                                            try await viewModel.setupStudentsListListener()
                                        } catch {
                                            print("Error removing student: \(error)")
                                        }
                                    }
                                }
     
                        }
                    }
                    
                    
                }
                .onAppear {
                    Task {
                        do {
                            try await viewModel.setupStudentsListListener()
                    
                            
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
                #if os(iOS)
                .navigationTitle("My Office Hours")
                .navigationBarItems(trailing: EditButton())
                #endif
                
                
                Spacer()
                Button {
                    showingEndOHAlert = true
                   
                
                    
                } label: {
                    Text("End Office Hours")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .controlSize(.large)
                .padding()
                .alert(isPresented: $showingEndOHAlert) {
                    Alert(title: Text("End Office Hours?"), message: Text("Are you sure?"), primaryButton: .destructive(Text("End")) {
                        Task{
                            do {
                                try await viewModel.endOh(joinCode: joinCode)
                            } catch {
                                print("Error")
                            }
                        }
                        
                    }, secondaryButton: .cancel())
                    
                }
            
            
            }
        }
    }


struct StudentEntry: View {
    @EnvironmentObject var viewModel: AuthViewModel
    let studentName: String
    @Binding var joinCode: String
    var body: some View {
        
            HStack {
                Image(systemName: "graduationcap")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                    .padding(.leading, 8)
                Text(studentName)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }
            
            
        
        
       
    }
}




