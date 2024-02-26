//
//  ClassCodeGeneration.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/21/24.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct ClassJoinCodeGeneration: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(entity: Instructor.entity(), sortDescriptors: []) var entities: FetchedResults<Instructor>
    
    @State var email = String()
    @State var password = String()

    @State var navigateToDashboard = false
    @State var qrCode: Image?
    @State var joinCode: String = String()

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
                
                Text(joinCode)
                Spacer()
                    .frame(height: 20)
                Text("Or give your students this QR Code")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                if let qrCode = qrCode {
                    qrCode
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Text("Generating QR code..")
                }
                
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
            .onAppear {
                let generatedJoinCode = generateJoinCode()
                joinCode = generatedJoinCode
                DataController().saveJoinCode(joinCode: joinCode, context: managedObjContext)
                
                generateQRCode()
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
    
    func setlatestemailandpassword() {
        if let thecurremail = entities.last?.email, let currpassword = entities.last?.password{
            email = thecurremail
            password = currpassword
        }
        navigateToDashboard = true
        
    }
    
    
    
}

func generateJoinCode() -> String {
    //Generate a random, alphanumeric string with hyphens.
    let randomString = UUID().uuidString
    //Then, remove the hyphens and shorten the code to 5 characters.
    let joinCode = randomString.replacingOccurrences(of: "-", with: "").prefix(5)
    
    return String(joinCode)
}

#Preview {
    ClassJoinCodeGeneration()
}
