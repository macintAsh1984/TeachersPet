//
//  OHLineManagement.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 3/1/24.
//

import SwiftUI

struct OHLineManagement: View {
    @State var students = [
        "Student A",
        "Student B",
        "Student C",
        "Student D"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<students.count, id: \.self) { index in
                        StudentEntry(studentInLine: students[index])
                  }
                    .onDelete { indexSet in
                        students.remove(atOffsets: indexSet)
                    }
//                    .onMove { indices, newOffset in
//                        students.move(fromOffsets: indices, toOffset: newOffset)
//                    }
                }
                .navigationTitle("My Office Hours")
                .navigationBarItems(trailing: EditButton())

            }
        }
    }
}


struct StudentEntry: View {
    @State var studentInLine: String
    
    var body: some View {
            NavigationStack {
                  HStack {
                      Image(systemName: "graduationcap")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 30, height: 30)
                      .cornerRadius(5)
                      .padding(.leading, 8)
                    Text(studentInLine)
                      .font(.headline)
                      .lineLimit(1)
                    Spacer()
                  }
                  .padding(.vertical, 8)
                }

    }
}


#Preview {
    OHLineManagement()
}
