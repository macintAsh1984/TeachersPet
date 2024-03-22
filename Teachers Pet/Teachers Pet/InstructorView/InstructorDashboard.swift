//
//  StudentDashboard.swift
//  Teachers Pet
//
//  Created by Sai Ganesh Chamarty on 2/28/24.
//

import SwiftUI

struct InstructorDashboard: View {
    @State var accessCode = String()
    @State private var navigateToDashBoard = false
    @State var navigateToWelcomeScreen = false
    @State private var date = Date()
    @State var currentOfficeHours: [OfficeHoursViewModel] = []
    @EnvironmentObject var officeHoursViewModel: OfficeHoursViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showClassInfo = false
    
    @Binding var email: String
    @Binding var joinCode: String
    @State var signOut = false
    @State var coursename = ""
    
    //This object is temporary and will be removed after the implementation of class settings.
    let officeHour1 = OfficeHoursViewModel(className: "", month: "February", day: 26, startHour: 9, endHour: 10, buildingName: "Teaching and Learning Complex", roomNumber: 2216, profName: "")
    
    var body: some View {
        NavigationStack{
            
            VStack {
                HStack {
                    Text("Your Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .onAppear{
                            currentOfficeHours = [officeHour1]
                            Task {
                                await viewModel.getCourseNameForInstructors()
                            }
                        }
                    Spacer()
                    AccountButton(signOut: $signOut)
                }
                .padding(2)
                Spacer()
                    .frame(height: 20)
                HStack {
                    Text("Current Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                }
                .padding(5)
                .padding(.bottom)
                
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
                OHLineManagement(joinCode: $joinCode)
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
