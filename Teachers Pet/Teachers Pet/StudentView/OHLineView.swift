//
//  OHLineView.swift
//  Teachers Pet
//
//  Created by Roshini Pothapragada on 2/29/24.
//

#if canImport(ActivityKit)
import ActivityKit
#endif
import SwiftUI

struct OHLineView: View {
    //User Account Info Bindings
    @Binding var email: String
    @Binding var joinCode: String
    
    //Alert & Navigation Toggle State Variables
    @State var leaveLineAlert = false
    @State var returnToStudentDashboard = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    //Live Activity Binding
    #if os(iOS)
    @Binding var activity: Activity<OfficeHoursAttribute>?
    #endif
    
    
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
            .navigationDestination(isPresented: $returnToStudentDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
        }
    }
    
    #if os(iOS)
    func updateLiveActivity(newPosition: Int) {
        Task {
            let updatedState = OfficeHoursAttribute.ContentState(linePosition: newPosition)
            let content = ActivityContent(state: updatedState, staleDate: nil)
            await activity?.update(content)
        }
    }

    func endLiveActivity() {
        let state = OfficeHoursAttribute.ContentState(linePosition: viewModel.positionInLine)
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.end(content, dismissalPolicy:.immediate)
        }
    }
    #endif
}

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
        .tint(.orange)
        .controlSize(.large)

    }
}
