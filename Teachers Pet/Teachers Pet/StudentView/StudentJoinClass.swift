// Created by Toniya on 2/29/24

import SwiftUI
#if canImport(CodeScanner)
import CodeScanner
#endif
//above part is to only have scanner if available like on iphone or ipad

struct StudentJoinClass: View {
    @State var joinCode = String()
  //  @State private var navigateToDashBoard = false
    @State var showScanner = false
    @State var email: String
    let Name: String
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    @State var navigatetoStudentDashboard = false
    
    var body: some View {
        VStack {
            Text("Access Code")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
            
            Text("Enter The Code Manually")
            TextField("Access Code", text: $joinCode)
                .padding(.all)
                .background()
                .cornerRadius(10.0)
            
            Spacer()
                .frame(height: 100)
            Button {
                showScanner = true
            } label: {
                Label("Or Scan A QR Code", systemImage: "qrcode.viewfinder")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            Button(action: {
                // Handle button action here, e.g., pass 'joinCode' to the function that joins the professor's class
                Task {
                    do {
                        try await viewModel.joinClassAsStudent(joinCode: joinCode, Name: Name, email: email)
                        navigatetoStudentDashboard = true
                    }catch {
                        print("Error signing in")
                    }
                }
            }) {
                Text("Join Class")
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.large)
            
            
            
            Spacer()
        } // end of VStack
        
        .padding()
        .background(Color("AppBackgroundColor"))
        .preferredColorScheme(.light)
        
        
        //for simulator to work
         #if os(iOS)
        .sheet(isPresented: $showScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "7A04A", completion: handleScan)
        }
        #endif
        .navigationDestination(isPresented: $navigatetoStudentDashboard) {
            StudentDashboard(email: $email, joinCode: $joinCode)
        }
         Spacer()
    }// end of view
 
 #if os(iOS)
 func handleScan(result: Result<ScanResult, ScanError>) {
    showScanner = false
     switch result {
     case .success(let result):
         let details = result.string
         joinCode = details
         
     case .failure(let error):
         print("Scanning failed: \(error.localizedDescription)")
     }
 }
 #endif
}

//#Preview {
//    StudentJoinClass()
//}
