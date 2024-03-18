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
    
    //the following objects are temporary and will be removed after implementation of class settings.
    let officeHour1 = OfficeHoursViewModel(className: "ECS 154A", month: "February", day: 26, startHour: 9, endHour: 10, buildingName: "Teaching and Learning Complex", roomNumber: 2216, profName: "Farrens")
    
    let currentOH1 = OfficeHoursViewModel(className: "Acting Class", month: "March", day: 13, startHour: 6, endHour: 7, buildingName: "Mondavi Center", roomNumber: 36, profName: "Jim Carry")
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Text("Your Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .onAppear{
                            upcomingClasses = [officeHour1]
                            currentOfficeHours = [currentOH1]
                            Task {
                                await viewModel.getCourseName()
                            }
                        }
                    Spacer()
                    
                    AccountButton(signOut: $signOut)
                }
                
                .padding(2)
                
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    Text("Upcoming Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                    
                    //calender button to be implemented
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.green)
                }
                .padding(5)
                .padding(.bottom)
                //upcoming class button(s)
                
                ForEach(upcomingClasses.indices, id: \.self){ index in
                    UpcomingClasses(showClassInfo: $showClassInfo, upcomingClasses: $upcomingClasses, index: Binding<Int>(get: { index},set: { newValue in}))
                }
                
                HStack {
                    Text("Current Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                }
                .padding()
                //current office hours buttons
                
                ForEach(currentOfficeHours.indices, id: \.self){ index in
                    CurrentOfficeHours(showClassInfo: $showClassInfo, currentOfficeHours: $currentOfficeHours, index: Binding<Int>(get: { index},set: { newValue in}))
                }
                Spacer()
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
            coursename = viewModel.coursename
        }
    }
}


//account button
struct AccountButton: View {
    @Binding var signOut: Bool
    var body: some View {
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
                .foregroundColor(.green)
                .padding(5)
        } //end of menu options
    }
}

//Upcoming classes for users to navigate to their respective classes
struct UpcomingClasses: View {
    
    @Binding var showClassInfo: Bool
    @Binding var upcomingClasses: [OfficeHoursViewModel]
    @EnvironmentObject var officeHoursViewModel: OfficeHoursViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var index: Int

    var body: some View {
        Button(action: {
            showClassInfo = true
        }, label: {
            
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 110)
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.black, .green]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(20)

                VStack (alignment: .leading){
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 120, height: 40)
                            .foregroundStyle(.green)
                        
                        Text("\(viewModel.coursename)")
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
}

//Current Office Hours buttons for users to navigate to their respctive classes
struct CurrentOfficeHours: View {
    @Binding var showClassInfo: Bool
    @Binding var currentOfficeHours: [OfficeHoursViewModel]
    @Binding var index: Int
    var body: some View {
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
    }
}

#Preview {
    StudentDashboard(email: .constant(""), joinCode: .constant(""))
}
