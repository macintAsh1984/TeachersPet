//
//  StudentDashboard.swift
//  Teachers Pet
//
//  Created by Sai Ganesh Chamarty on 2/28/24.
//

// MARK: - StudentDashboard
import SwiftUI

struct StudentDashboard: View {
    
    //User Account Information Binding/State Variables
    @Binding var email: String
    @Binding var joinCode: String
    
    // State variables for the dashboard.
    @State var accessCode = String()
    @State private var navigateToDashBoard = false
    @State var navigateToWelcomeScreen = false
    @State private var date = Date()
    @State var currentOfficeHours: [OfficeHoursViewModel] = []
    @State var showClassInfo = false
    @State var signOut = false
    @State var coursename = ""
    
    @EnvironmentObject var officeHoursViewModel: OfficeHoursViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    // This object is temporary and will be removed after the implementation of class settings.
    let officeHour1 = OfficeHoursViewModel(className: "", month: "February", day: 26, startHour: 9, endHour: 10, buildingName: "Teaching and Learning Complex", roomNumber: 2216, profName: "")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Your Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .onAppear {
                            currentOfficeHours = [officeHour1]
                            Task {
                                await viewModel.getCourseName()
                            }
                        }
                    Spacer()
                    AccountButton(signOut: $signOut)
                }
                .padding(2)
                Spacer().frame(height: 20)
                HStack {
                    Text("Current Office Hours")
                        .font(.custom("sideheading", size: 23))
                    Spacer()
                }
                .padding(5)
                .padding(.bottom)
                
                // Current class office hours button(s)
                ForEach(currentOfficeHours.indices, id: \.self) { index in
                    CurrentOfficeHours(showClassInfo: $showClassInfo, currentOfficeHours: $currentOfficeHours, index: Binding<Int>(get: { index }, set: { newValue in }))
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden()
            .background(appBackgroundColor)
            .navigationDestination(isPresented: $showClassInfo) {
                OHQuestionaire(email: $email, joinCode: $joinCode)
            }
            .navigationDestination(isPresented: $navigateToWelcomeScreen) {
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
    
    
    // MARK: - Function SetCourseName
    // Function to set the course name.
    func setCourseName() {
        Task {
            coursename = viewModel.courseName
        }
    }
}

// MARK: - AccountButton
// Account button
struct AccountButton: View {
    @Binding var signOut: Bool
    
    var body: some View {
        Menu {
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
        } // End of menu options
    }
}


// MARK: - CurrentOfficeHours
// Upcoming classes for users to navigate to their respective classes.
struct CurrentOfficeHours: View {
    @Binding var showClassInfo: Bool
    @Binding var currentOfficeHours: [OfficeHoursViewModel]
    @EnvironmentObject var officeHoursViewModel: OfficeHoursViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var index: Int
    
    var body: some View {
        Button(action: {
            showClassInfo = true
        }, label: {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 110)
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.black, .green]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(20)
                VStack(alignment: .leading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 120, height: 40)
                            .foregroundStyle(.green)
                        Text("\(viewModel.courseName)")
                            .foregroundStyle(.white)
                            .bold()
                    }
                    Text("\(currentOfficeHours[index].month) \(currentOfficeHours[index].day), \(currentOfficeHours[index].startHour) - \(currentOfficeHours[index].endHour)")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                    Text("\(currentOfficeHours[index].buildingName), \(currentOfficeHours[index].roomNumber)")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                }
                .padding(.leading)
            }
        })
        .padding(.bottom)
    }
}
