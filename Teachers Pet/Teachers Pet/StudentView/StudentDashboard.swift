//
//  StudentDashboard.swift
//  Teachers Pet
//
//  Created by Sai Ganesh Chamarty on 2/28/24.
//

import SwiftUI

struct StudentDashboard: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @State var accessCode = String()
    @State private var navigateToDashBoard = false
    @State var navigateToWelcomeScreen = false
    @State private var date = Date()
    @State var upcomingClasses: [OfficeHoursViewModel] = []
    @State var currentOfficeHours: [OfficeHoursViewModel] = []
    @EnvironmentObject var officeHoursViewModel: OfficeHoursViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showClassInfo = false
    
    @Binding var email: String
    @Binding var joinCode: String
    @State var signOut = false
    @State var coursename = ""
    
    var body: some View {
        NavigationStack{
            let officeHour1 = OfficeHoursViewModel(className: "ECS 154A", month: "February", day: 26, startHour: 9, endHour: 10, buildingName: "Teaching and Learning Complex", roomNumber: 2216, profName: "Farrens")
            let officeHour2 = OfficeHoursViewModel(className: "ECS 189E", month: "February", day: 28, startHour: 9, endHour: 10, buildingName: "Kemper Hall", roomNumber: 1553, profName: "Sam King")
            
            let currentOH1 = OfficeHoursViewModel(className: "Acting Class", month: "March", day: 13, startHour: 6, endHour: 7, buildingName: "Mondavi Center", roomNumber: 36, profName: "Jim Carry")
            
            VStack {
                HStack {
                    Text("Your Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .onAppear{
                            upcomingClasses.append(officeHour1)
                            currentOfficeHours = [currentOH1]
                            Task {
                                await viewModel.getCourseName()
                            }
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
                Spacer()
                    .frame(height: 20)
                HStack {
                    Text("Upcoming Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                    Button(action: {
                        // Action to perform when the button is tapped
                        print("Button tapped!")
                    }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.orange)
                    }
                }
                .padding(5)
                .padding(.bottom)
                
                ForEach(upcomingClasses.indices, id: \.self){ index in
                    Button(action: {
                        showClassInfo = true
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
                                    
                                    Text("\(viewModel.courseName)")
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
                        showClassInfo = true
                    }, label: {
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 105)
                                .foregroundColor(.white)
                            VStack {
                                HStack {
                                    Text("\(currentOfficeHours[index].className)")
                                        .foregroundStyle(.black)
                                        .bold()
                                        .padding(.leading)
                                    Spacer()
                                    Text("Prof. \(currentOfficeHours[index].profName)")
                                        .foregroundStyle(.black)
                                        .padding(.trailing)
                                }
                                HStack {
                                    Text("Wednesday, March \(currentOfficeHours[index].day)")
                                        .padding(.leading)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Text("\(currentOfficeHours[index].startHour) - \(currentOfficeHours[index].endHour) PM")
                                        .padding(.trailing)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    })
                    .padding(.bottom)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden()
            .background(appBackgroundColor)
            .navigationDestination (isPresented: $showClassInfo) {
                OHQuestionaire(email: $email, joinCode: $joinCode)
            }
            .navigationDestination (isPresented: $navigateToWelcomeScreen) {
                WelcomeScreen()
            }
            .alert(isPresented: $signOut) {
                Alert(
                    title: Text("Are you sure you want to sign out"),
                    message: Text("This cannot be undone."),
                    primaryButton: .destructive(Text("Sign Out")) {
                        viewModel.signout()
                        navigateToWelcomeScreen = true
                        
                    },
                    secondaryButton: .cancel()
                    
                )
            }
            Spacer()
            
        }
        .background(appBackgroundColor)

    }
    
    func setCourseName() {
        Task{
            coursename = viewModel.courseName
        }
    }
}

#Preview {
    StudentDashboard(email: .constant(""), joinCode: .constant(""))
}
