//
//  ClassCodeGeneration.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/21/24.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct ClassJoinCodeGeneration: View {
    //User Account Info Bindings/State Variables
    @Binding var email: String
    @Binding var password: String
    @Binding var Name: String
    @Binding var coursename: String
    @State var joinCode: String = String()
    @State var showAlert = true
    @State var alertMessage = ""
    
    //Navigation & QR Code Generation State Variables
    @State var navigateToDashboard = false
    @State var qrCode: Image?
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                DisplayJoinCode(courseName: $coursename, joinCode: $joinCode)
                DisplayQRCode(qrCode: $qrCode)
                GoToDashboardButton(navigateToDashboard: $navigateToDashboard)
                Spacer()
                
            }
            .padding()
            .preferredColorScheme(.light)
            .background(appBackgroundColor)
//            .alert(alertMessage, isPresented: $showAlert) {
//                Button("OK") { }
//            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $navigateToDashboard) {
                InstructorDashboard(email: $email, joinCode: $joinCode)
            }
            .onAppear {
                let generatedJoinCode = generateJoinCode()
                joinCode = generatedJoinCode
                Task {
                    try await viewModel.createUser(withEmail:email, password: password, fullname: Name, coursename: coursename, joincode: joinCode) //only first name for now fix this to have both
                }
                generateQRCode()
            }
        }
       
    }
    
    func generateJoinCode() -> String {
        //Generate a random, alphanumeric string with hyphens.
        let randomString = UUID().uuidString
        //Then, remove the hyphens and shorten the code to 5 characters.
        let joinCode = randomString.replacingOccurrences(of: "-", with: "").prefix(5)
        
        return String(joinCode)
    }
    
    func generateQRCode()  {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        if let data = joinCode.data(using: .utf8) {
            filter.message = data
        }

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                #if os(macOS)
                qrCode = Image(nsImage: NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height)))
                #else
                qrCode = Image(uiImage: UIImage(cgImage: cgImage))
                #endif
            }
        }
    }

}

struct DisplayJoinCode: View {
    @Binding var courseName: String
    @Binding var joinCode: String
    
    var body: some View {
        Text("\(courseName) Join Code")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        Text(joinCode)
            .font(.title2)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        Spacer()
            .frame(height: 20)
        Text("Or give your students this QR Code")
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
}

struct DisplayQRCode: View {
    @Binding var qrCode: Image?
    
    var body: some View {
        if let qrCode = qrCode {
            qrCode
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        } else {
            Text("Generating QR code..")
        }
    }
}

struct GoToDashboardButton: View {
    @Binding var navigateToDashboard: Bool
    
    var body: some View {
        Button {
            navigateToDashboard = true
        } label: {
            Text("Go To Dashboard")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .controlSize(.large)
    }
}
