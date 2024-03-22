//
//  OHLineView.swift
//  Teachers Pet
//
//  Created by Roshini Pothapragada on 2/29/24.
//

// MARK: - OHLineView
#if canImport(ActivityKit)
import ActivityKit
#endif
import SwiftUI

struct OHLineView: View {
    // User Account Info Bindings
    @Binding var email: String
    @Binding var joinCode: String
    
    // Alert & Navigation Toggle State Variables
    @State var leaveLineAlert = false
    @State var returnToStudentDashboard = false
    @State var studentInQueueStill = false
    @State var navigateToDashboard = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    // Live Activity Binding
    #if os(iOS)
    @Binding var activity: Activity<OfficeHoursAttribute>?
    #endif
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                DisplayLinePosition()
                    .environmentObject(viewModel)
                LeaveOfficeHoursButton(willLeave: $leaveLineAlert)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
            .onAppear {
                Task {
                    try await viewModel.addListnerToLine(joinCode: joinCode)
                }
            }
            
            #if os(iOS)
            .onChange(of: viewModel.positionInLine) { newPosition in
                let state = UIApplication.shared.applicationState
                switch state {
                case .active, .inactive, .background:
                    updateLiveActivity(newPosition: newPosition)
                default:
                    updateLiveActivity(newPosition: newPosition)
                }
            }
            #endif
            
            .alert(isPresented: $leaveLineAlert) {
                Alert(
                    title: Text("Are you sure you want to leave the line?"),
                    message: Text("This cannot be undone."),
                    primaryButton: .destructive(Text("Leave")) {
                        Task {
                            try await viewModel.removeStudentFromLine(joinCode: joinCode, email: email)
                        }
                        #if os(iOS)
                        endLiveActivity()
                        #endif
                        
                        returnToStudentDashboard = true
                    },
                    secondaryButton: .cancel()
                    
                )
            }
            .onChange(of: returnToStudentDashboard) { newValue in
                navigateToDashboard = newValue
            }
            .onChange(of: viewModel.studentHasBeenRemoved) { newValue in
                navigateToDashboard = newValue
            }
            .navigationDestination(isPresented: $returnToStudentDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
            .navigationDestination(isPresented: $navigateToDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
        }
    }
    
    
    // MARK: - Live Activity
    #if os(iOS)
    // Update the live activity with new position
    func updateLiveActivity(newPosition: Int) {
        Task {
            let updatedState = OfficeHoursAttribute.ContentState(linePosition: newPosition)
            let content = ActivityContent(state: updatedState, staleDate: nil)
            await activity?.update(content)
        }
    }
    

    // End the live activity
    func endLiveActivity() {
        let state = OfficeHoursAttribute.ContentState(linePosition: viewModel.positionInLine)
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
    #endif
}


// MARK: - DisplayLinePosition
// Display the position of the user in the line
struct DisplayLinePosition: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Text("You are")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        if viewModel.positionInLine != 1 {
            Text("#\(viewModel.positionInLine)")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("in line!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        } else {
            Text("Up Next!")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}


// MARK: - LeaveOfficeHoursButton
// Button to leave the office hours line
struct LeaveOfficeHoursButton: View {
    @Binding var willLeave: Bool
    
    var body: some View {
        Button {
            willLeave = true
        } label: {
            Text("Leave Office Hours Line")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .controlSize(.large)

    }
}
