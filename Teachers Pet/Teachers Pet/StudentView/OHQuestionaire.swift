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
    @State var navigateToStudentDashboard = false
    @State var studentAlreadyInLine = false
    @State var isLoading = false
    
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
                Text("Office Hours Survey")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                
                ForEach(0..<4, id: \.self) { index in
                    Button(action: {
                        // Toggle selection
                        if self.selectedOption == index {
                            self.selectedOption = nil // Deselect if already selected
                        } else {
                            self.selectedOption = index
                        }
                    }){
                        HStack {
                            Text(options[index])
                                .fontWeight(.medium)
                            Spacer()
                            if self.selectedOption == index {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding()
                        .background(self.selectedOption == index ? .blue : .green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                    .frame(height: 20)
                
                // Textfield for adding additional details.
                TextField("Add additional details here", text: $otherOptionText)
                    .frame(width: 325, height: 20)
                    .padding(.all)
                    .background(.white)
                    .cornerRadius(10.0)
                Spacer()
                    .frame(height: 20)
                
                // Loading...
                if isLoading {
                    ProgressView() // Show loading indicator
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Button(action: {
                        // Handle the submission here, including the selected option or the text from the TextField
                        submitSurvey()
                        
                        //Add the student to the line before calculating their place in line.
                        let addStudentTask = Task {
                            do {
                                studentAlreadyInLine = try await viewModel.addStudentToLine(joinCode: joinCode, email: email)
                            } catch {
                                print("Couldn't add you to the line :(.")
                            }
                        }
                        
                        isLoading = true // Show Loading
                        Task {
                            //Wait for student to be added to the line before running this task.
                            _ = await addStudentTask.result
                            if studentAlreadyInLine {
                                navigateToOfficeHoursLine = false
                            } else {
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
                            isLoading = false
                        } //end of Task
                        
                    }) {
                        Text("Join Queue")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .background(.green)
                            .cornerRadius(10)
                    }
                }//end of else
                
            }
            .onAppear {
                if let currentUser = viewModel.currentUser {
                    joinCode = currentUser.joincode
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(appBackgroundColor)
            .preferredColorScheme(.light)
            .navigationDestination(isPresented: $navigateToOfficeHoursLine) {
                #if os(iOS)
                OHLineView(email: $email, joinCode: $joinCode, activity: $activity)
                #else
                OHLineView(email: $email, joinCode: $joinCode)
                #endif
            }
            .navigationDestination(isPresented: $navigateToStudentDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
            .alert(isPresented: $studentAlreadyInLine) {
                Alert(
                    title: Text("Cannot Join Line"),
                    message: Text("You are already in the Office Hours line for this class."),
                    primaryButton: .default(Text("See Place In Line")) {
                        Task {
                            try await viewModel.calculateLinePosition(joinCode: joinCode, email: email)
                            navigateToOfficeHoursLine = true
                        }
                    },
                    secondaryButton: .destructive(Text("Leave Line")) {
                        Task {
                            try await viewModel.removeStudentFromLine(joinCode: joinCode, email: email)
                            navigateToStudentDashboard = true
                        }
                    }
                )
                
            }
        }
    }
    
#if os(iOS)
    func beginLiveActivity() {
        let attributes = OfficeHoursAttribute(activityTitle: "\(String(describing: viewModel.currentUser?.coursename)) Office Hours")
        let activityState = OfficeHoursAttribute.LiveActivityStatus(linePosition: viewModel.positionInLine)
        activity = try? Activity<OfficeHoursAttribute>.request(attributes: attributes, content: .init(state: activityState, staleDate: nil))
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

