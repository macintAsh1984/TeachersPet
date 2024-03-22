//
//  OHQuestionaire.swift
//  Teachers Pet
//
//  Created by Roshini Pothapragada on 2/29/24.
//

// MARK: - OHQuestionaire
#if canImport(ActivityKit)
import ActivityKit
#endif
import SwiftUI

struct OHQuestionaire: View {
    
    // MARK: - State Variables
    // State variables for the questionnaire.
    @State private var selectedOption: Int? = nil
    @State private var otherOptionText: String = ""
    @State var navigateToOfficeHoursLine = false
    @State var navigateToStudentDashboard = false
    @State var studentAlreadyInLine = false
    @State var isLoading = false
    @State var noOptionSelected = false
    
    // MARK: - Binding Variables
    // Binding variables
    @Binding var email: String
    @Binding var joinCode: String
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    #if os(iOS)
    @State var activity: Activity<OfficeHoursAttribute>? = nil
    #endif
    
    // MARK: - Options
    // Options for the questionnaire
    var options = [
        "Need help getting started",
        "Stuck on a certain part",
        "Regrade/Re-submission",
        "Just a chat with professor"
    ]
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: Title
                Text("Office Hours Survey")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                
                // MARK: Options
                ForEach(0..<4, id: \.self) { index in
                    Button(action: {
                        // Toggle Selection
                        if self.selectedOption == index {
                            // Deselect if already selected
                            self.selectedOption = nil
                        } else {
                            self.selectedOption = index
                        }
                    }) {
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
                Spacer().frame(height: 20)
                
                // MARK: Additional Details
                // TextField for adding additional details
                TextField("If other, please specify", text: $otherOptionText)
                    .frame(width: 325, height: 20)
                    .padding(.all)
                    .background(.white)
                    .cornerRadius(10.0)
                Spacer().frame(height: 20)
                
                // MARK: Loading Indicator / Join Queue Button
                // Loading indicator or Join Queue button
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Button(action: {
                        
                        if selectedOption == nil {
                            noOptionSelected = true
                        }
                        
                        else {
                            // Handle the submission
                            
                            submitSurvey()
                            let addStudentTask = Task {
                                do {
                                    studentAlreadyInLine = try await viewModel.addStudentToLine(joinCode: joinCode, email: email)
                                } catch {
                                    print("Couldn't add student to the line.")
                                }
                            }
                            
                            isLoading = true // Show loading indicator
                            Task {
                                
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
                                        print("Couldn't calculate position.")
                                    }
                                }
                                isLoading = false
                            }
                        }
                    }) {
                        Text("Join Queue")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .background(.green)
                            .cornerRadius(10)
                    }
                }
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
            .alert(isPresented: $noOptionSelected) {
                Alert(
                    title: Text("No Option Selected"),
                    message: Text("Please select an Option."),
                    dismissButton: .cancel(Text("OK"))
                )
                
            }
        }
    }
    
    // MARK: - Begin Live Activity
    #if os(iOS)
    // Begin the live activity for the office hours
    func beginLiveActivity() {
        let attributes = OfficeHoursAttribute(activityTitle: "\(String(describing: viewModel.currentUser?.coursename)) Office Hours")
        let activityState = OfficeHoursAttribute.LiveActivityStatus(linePosition: viewModel.positionInLine)
        activity = try? Activity<OfficeHoursAttribute>.request(attributes: attributes, content: .init(state: activityState, staleDate: nil))
    }
    #endif
    
    
    // MARK: - Submit Survey
    // Function to submit the survey data
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
