//
//  OHQuestionaire.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/29/24.
//

import SwiftUI

struct OHQuestionaire: View {
    @State private var selectedOption: Int? = nil
    @State private var otherOptionText: String = ""
    
    var options = [
        "Need help getting started",
        "Stuck on a certain part",
        "Regrade/Re-submission",
        "Just a chat with professor"
    ]
    
    var body: some View {
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
            }) {
                Text("Join Queue")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            
        }
    }
    
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



#Preview {
    OHQuestionaire()
}
