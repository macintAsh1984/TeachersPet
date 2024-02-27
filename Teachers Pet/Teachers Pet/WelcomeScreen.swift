//
//  ContentView.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/5/24.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @State var navigateToCreateAccount = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome To Teacher's Pet")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("I am a...")
                    .font(.headline)
                Spacer()
                    .frame(height: 20)
                
                Button {
                    navigateToCreateAccount = true
                } label: {
                    Text("Student")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .controlSize(.large)
                
                Button {
                    navigateToCreateAccount = true
                } label: {
                    Text("Instructor")
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding()
            .background(Color("AppBackgroundColor"))
            .preferredColorScheme(.light)
            .navigationDestination(isPresented: $navigateToCreateAccount) {
                CreateAccount()
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
