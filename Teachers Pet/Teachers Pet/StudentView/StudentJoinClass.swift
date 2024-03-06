// Created by Toniya on 2/29/24

import SwiftUI
#if canImport(CodeScanner)
import CodeScanner
#endif
//above part is to only have scanner if available like on iphone or ipad

struct StudentJoinClass: View {
    @State var joinCode = String()
    @State var showScanner = false
    
    @Binding var email: String
    @Binding var name: String
    @Binding var password: String
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var navigatetoStudentDashboard = false
    @State var isLoading = false
    
    var body: some View {
        NavigationStack {
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
                
                #if os(iOS)
                Button {
                    showScanner = true
                } label: {
                    Label("Or Scan A QR Code", systemImage: "qrcode.viewfinder")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                }
                #endif
                Spacer()
                
                // Loading...
                if isLoading {
                    ProgressView() // Show loading indicator
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                else {
                    // Join Class button
                    Button(action: {
                        isLoading = true // Show loading
                        Task {
                            do {
                                // Firebase update
                                try await viewModel.createUserforStudent(withEmail: email, password: password, fullname: name, coursename: "", joincode: joinCode)
                                navigatetoStudentDashboard = true
                            } catch {
                                print("Error signing in")
                            }
                            
                            isLoading = false // Hide loading when firebase done updating
                        }
                    })
                    { //button text:
                        Text("Join Class")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .controlSize(.large)
                    .disabled(isLoading) // Disable "join class"
                }
                
                Spacer()
            } // end of VStack
            .padding()
            .background(appBackgroundColor)
            .preferredColorScheme(.light)
            .navigationDestination(isPresented: $navigatetoStudentDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
        
            
            // Scanner view for iOS
            #if os(iOS)
            .sheet(isPresented: $showScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "7A04A", completion: handleScan)
            }
            #endif
            Spacer()
        }
    }// end of view
    
    
    // Handle scanning result
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
