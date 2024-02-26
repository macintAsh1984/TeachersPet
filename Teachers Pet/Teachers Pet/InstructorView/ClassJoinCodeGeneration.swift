//
//  ClassCodeGeneration.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/21/24.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

// TODO: Save Class Join Code To Disk (in case instructors need it later)

struct ClassJoinCodeGeneration: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var navigateToDashboard = false
    @Binding var email:String
    @Binding var password: String
    @Binding var Name: String
    @Binding var coursename: String
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
              
                Text("\(coursename) Join Code")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            
                
                
                let joinCode = generateJoinCode()
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
                Image(uiImage: generateQRCode(from: "\(joinCode)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Button {
                    Task {
                        try await viewModel.createUser(withEmail:email, password: password, fullname: Name, coursename: coursename, joincode: joinCode) //only first name for now fix this to have both
                    }
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
                Spacer()
                
            }
            .padding()
            .preferredColorScheme(.light)
            .background(Color("AppBackgroundColor"))
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $navigateToDashboard) {
                Instructorview()
            }
            .onAppear()
            
            
        }
        
       
    }
    
    func generateJoinCode() -> String {
        //Generate a random, alphanumeric string with hyphens.
        let randomString = UUID().uuidString
        //Then, remove the hyphens and shorten the code to 5 characters.
        let joinCode = randomString.replacingOccurrences(of: "-", with: "").prefix(5)
        
        //DataController().saveJoinCode(joinCode: String(joinCode), context: managedObjContext)
        
        return String(joinCode)
    }
    
    func generateQRCode(from joinCode: String) -> UIImage {
        filter.message = Data(joinCode.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
   
    
    
    
}

//#Preview {
//    ClassJoinCodeGeneration()
//}
