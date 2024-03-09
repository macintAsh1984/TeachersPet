//
//  OHQuestionaire.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/29/24.
//

#if canImport(ActivityKit)
import ActivityKit
#endif
import SwiftUI

struct OHQuestionaire: View {
    @State private var selectedOption: Int? = nil
    @State private var otherOptionText: String = ""
    @State var navigateToOfficeHoursLine = false
    @State var isstudentalreadyinqueue = false
    
    @Binding var email: String
    @Binding var joinCode: String
    @EnvironmentObject var viewModel: AuthViewModel
    #if os(iOS)
    @State var activity: Activity<OfficeHoursAttribute>? = nil
    #endif

    var options = [
        "Need help getting started",
        "Stuck on a certain part",
        "Regrade/Re-submission",
        "Just a chat with professor"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Please answer the survey:")
                    .font(.title)
                    .padding()
                
                ForEach(0..<4, id: \.self) { index in
                    Button(action: {
                        // Toggle selection
                        if self.selectedOption == index {
                            self.selectedOption = nil // Deselect if already selected
                        } else {
                            self.selectedOption = index
                        }
                    }) {
                        HStack {
                            Text(options[index])
                            Spacer()
                            if self.selectedOption == index {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding()
                        .background(self.selectedOption == index ? Color.blue : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                // Textfield for other option
                TextField("If other, please specify here", text: $otherOptionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Handle the submission here, including the selected option or the text from the TextField
                    submitSurvey()
                    Task {
                        do {
                            try await viewModel.addStudentToLine(joinCode: joinCode, email: email)
                        } catch {
                            //print("Couldn't add you to the line :(.")
                            isstudentalreadyinqueue = true
                        }
                    }
                    
                    Task { //this needs fixing for frontend
                        if isstudentalreadyinqueue {
                            navigateToOfficeHoursLine = false
                        }
                        else {
                            do {
                                try await viewModel.calculateLinePosition(joinCode: joinCode, email: email)
                                
                                #if os(iOS)
                                beginLiveActivity()
                                #endif
                                
                                
                                navigateToOfficeHoursLine = true
                                
                                
                                
                            } catch {
                                print("Couldn't calculate position")
                            }
                        }
                    }
                    
                }) {
                    Text("Join Queue")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
            }
            .onAppear {
                if let currentUser = viewModel.currentUser {
                    joinCode = currentUser.joincode
                }
            }
            .background(appBackgroundColor)
            .preferredColorScheme(.light)
            .navigationDestination(isPresented: $navigateToOfficeHoursLine) {
                #if os(iOS)
                OHLineView(email: $email, joinCode: $joinCode, activity: $activity)
                #else
                OHLineView(email: $email, joinCode: $joinCode)
                #endif
            }
            .alert(isPresented: $isstudentalreadyinqueue) {
                Alert(title: Text("Error"), message: Text("You are already in the queue"), dismissButton: .default(Text("OK")))
            }
        
        }
    
    }
    
    #if os(iOS)
    func beginLiveActivity() {
        let attributes = OfficeHoursAttribute(activityTitle: "\(String(describing: viewModel.currentUser?.coursename)) Office Hours")
        let activityState = OfficeHoursAttribute.LiveActivityStatus(linePosition: viewModel.positionInLine)
        
        activity = try? Activity<OfficeHoursAttribute>.request(attributes: attributes, content: .init(state: activityState, staleDate: nil))
        print(activity.debugDescription)
    }
    #endif
    
    func submitSurvey() {
        // Perform actions to submit the survey data
        // You can access the selectedOption and otherOptionText here
        if let selectedOption = selectedOption {
            print("Survey submitted with selected option: \(options[selectedOption])")
        } else {
            print("Survey submitted with other option: \(otherOptionText)")
        }
    }
}


//
//#Preview {
//    OHQuestionaire(email: .constant(""))
//}
