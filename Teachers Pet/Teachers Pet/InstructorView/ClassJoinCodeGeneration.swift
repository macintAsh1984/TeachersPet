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
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(entity: Instructor.entity(), sortDescriptors: []) var entities: FetchedResults<Instructor>
    
    @State var navigateToDashboard = false
    @State var email = String()
    @State var password = String()
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if let thelatestcoursename = entities.last?.coursename {
                    Text("\(thelatestcoursename) Join Code")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                
                
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
                    setlatestemailandpassword()
                    //navigateToDashboard = true
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
                
                    InstructorDashboard(email: $email, password: $password)
    
                
                
            }
            
            
        }
        
       
    }
    
    func generateJoinCode() -> String {
        //Generate a random, alphanumeric string with hyphens.
        let randomString = UUID().uuidString
        //Then, remove the hyphens and shorten the code to 5 characters.
        let joinCode = randomString.replacingOccurrences(of: "-", with: "").prefix(5)
        
        DataController().saveJoinCode(joinCode: String(joinCode), context: managedObjContext)
        
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
    
    
    func setlatestemailandpassword() {
        if let thecurremail = entities.last?.email, let currpassword = entities.last?.password{
            email = thecurremail
            password = currpassword
        }
        navigateToDashboard = true
        
    }
    
    
    
}

#Preview {
    ClassJoinCodeGeneration()
}
