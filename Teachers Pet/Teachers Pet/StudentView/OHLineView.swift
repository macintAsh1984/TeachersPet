//
//  OHLineView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/29/24.
//

#if canImport(ActivityKit)
import ActivityKit
#endif
import SwiftUI

struct OHLineView: View {
    @State var leaveLineAlert = false
    @State var returnToStudentDashboard = false
    
    @Binding var email: String
    @Binding var joinCode: String
    @EnvironmentObject var viewModel: AuthViewModel
    
    #if os(iOS)
    @Binding var activity: Activity<OfficeHoursAttribute>?
    #endif
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("You are #\(viewModel.positionInLine) in queue!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                
                Button {
                    leaveLineAlert = true
                } label: {
                    Text("Leave Office Hours Line")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .controlSize(.large)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
            .alert(isPresented: $leaveLineAlert) {
                Alert(
                    title: Text("Are you sure you want to leave the line?"),
                    message: Text("This cannot be undone."),
                    primaryButton: .destructive(Text("Leave")) {
                        #if os(iOS)
                        let state = OfficeHoursAttribute.ContentState(linePosition: viewModel.positionInLine)
                        let content = ActivityContent(state: state, staleDate: nil)
                        Task {
                            await activity?.end(content, dismissalPolicy:.immediate)
                        }
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
}

//#Preview {
//    OHLineView()
//}
