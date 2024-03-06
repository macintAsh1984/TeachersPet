//
//  InstructorDashboard.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/21/24.
//

import SwiftUI

struct InstructorDashboard: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @State var accessCode = String()
    @State private var navigateToDashBoard = false
    @State private var date = Date()
    @State var upcomingClasses: [OfficeHoursViewModel] = []
    @State var currentOfficeHours: [OfficeHoursViewModel] = []
    @EnvironmentObject var officeHoursViewModel: OfficeHoursViewModel
    
    @State var signOut = false
    
    var body: some View {
        NavigationView{
            let officeHour1 = OfficeHoursViewModel(className: "ECS 154A", month: "February", day: 26, startHour: 9, endHour: 10, buildingName: "Teaching and Learning Complex", roomNumber: 2216, profName: "Farrens")
            let officeHour2 = OfficeHoursViewModel(className: "ECS 189E", month: "February", day: 28, startHour: 9, endHour: 10, buildingName: "Kemper Hall", roomNumber: 1553, profName: "Sam King")
            
            let currentOH1 = OfficeHoursViewModel(className: "ECS 160", month: "March", day: 21, startHour: 6, endHour: 7, buildingName: "Kemper", roomNumber: 36, profName: "Farrens")
            
            let currentOH2 = OfficeHoursViewModel(className: "ECS 140A", month: "April", day: 21, startHour: 3, endHour: 4, buildingName: "Young Hall", roomNumber: 184, profName: "Thakkar")
            
            VStack {
                HStack {
                    Text("Your Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .onAppear{
                            upcomingClasses = [officeHour1, officeHour2]
                            currentOfficeHours = [currentOH1, currentOH2]
                        }
                    Spacer()
                    Menu() {
                        
                        Button(role: .destructive) {
                            signOut = true
                            print("Button tapped!")
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .font(.title)
                                .foregroundColor(.orange)
                                .padding(5)
                        }
                        
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundColor(.orange)
                            .padding(5)
                    } //end of menu options
                }
                .padding(2)
                Spacer(minLength: 40)
                HStack {
                    Text("Upcoming Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                    Button(action: {
                        // Action to perform when the button is tapped
                        print("Button tapped!")
                    }) {
                        //                        Image(systemName: "calender")
                        //                            .foregroundColor(.orange)
                        //                            .font(.title)
                        //                            .padding(5)
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.orange)
                    }
                    //                    DatePicker(
                    //                            "Start Date",
                    //                            selection: $date,
                    //                            displayedComponents: [.date]
                    //                        )
                    //                        .datePickerStyle(.graphical)
                }
                .padding(5)
                .padding(.bottom)
                
                ForEach(upcomingClasses.indices, id: \.self){ index in
                    Button(action: {
                        //class 1 -> go to class page
                    }, label: {
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 110)
                                .foregroundColor(.clear)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.black, .orange]), startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(20)
                            VStack (alignment: .leading){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 120, height: 40)
                                        .foregroundStyle(.orange)
                                    
                                    Text("\(upcomingClasses[index].className)")
                                        .foregroundStyle(.white)
                                        .bold()
                                    
                                }

                                Text("\(upcomingClasses[index].month) \(upcomingClasses[index].day), \(upcomingClasses[index].startHour) - \(upcomingClasses[index].endHour)")
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                                Text("\(upcomingClasses[index].buildingName), \(upcomingClasses[index].roomNumber)")
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                            }
                            .padding(.leading)
                        }
                    })
                    .padding(.bottom)
                }
                
                HStack {
                    Text("Current Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                }
                .padding()
                ForEach(currentOfficeHours.indices, id: \.self){ index in
                    Button(action: {
                        //class 1 -> go to class page
                    }, label: {
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 105)
                                .foregroundColor(.white)
                            VStack {
                                HStack {
                                    Text("\(upcomingClasses[index].className)")
                                        .foregroundStyle(.black)
                                        .bold()
                                        .padding(.leading)
                                    Spacer()
                                    Text("Prof. \(currentOfficeHours[index].profName)")
                                        .foregroundStyle(.black)
                                        .padding(.trailing)
                                }
                                HStack {
                                    Text("Monday, Feb \(currentOfficeHours[index].day)")
                                        .padding(.leading)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Text("\(currentOfficeHours[index].startHour) - \(currentOfficeHours[index].endHour)")
                                        .padding(.trailing)
                                        .foregroundStyle(.black)
                                }
                                
                            }
                        }
                        
                    })
                    .padding(.bottom)
                }
            }
            .padding()
            .navigationBarBackButtonHidden()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
            .alert(isPresented: $signOut) {
                Alert(
                    title: Text("Are you sure you want to sign out"),
                    message: Text("This cannot be undone."),
                    primaryButton: .destructive(Text("Sign Out")) {
                        //Sign out of account.
                        
                    },
                    secondaryButton: .cancel()
                    
                )
            }
            Spacer()
            
        }
    }
}

#Preview {
    InstructorDashboard()
}


//#Preview {
//    InstructorDashboard(email: .constant(""), password: .constant(""))
//}
