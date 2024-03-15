// Created by Toniya on 2/29/24

import SwiftUI
#if canImport(CodeScanner)
import CodeScanner
#endif

struct StudentJoinClass: View {
    //User Account Information Binding/State Variables
    @Binding var email: String
    @Binding var name: String
    @Binding var password: String
    @State var joinCode = String()
    
    //Navigation & View Toggle State Variables
    @State var navigatetoStudentDashboard = false
    @State var showScanner = false
    @State var isLoading = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Enter Class Join Code")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(height: 60)
                JoinCodeTextField(joinCode: $joinCode)
                Spacer()
                    .frame(height: 50)
                
                #if os(iOS)
                ScanQRCodeButton(showScanner: $showScanner)
                #endif
                Spacer()
                    .frame(height: 50)
                
                //Show loading indicator.
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Button {
                        createStudentAccount()
                    } label: {
                        Text("Join Class")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .controlSize(.large)
                    .disabled(isLoading)
                }
                Spacer()
            } // end of VStack
            .padding()
            .background(appBackgroundColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.light)
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $navigatetoStudentDashboard) {
                StudentDashboard(email: $email, joinCode: $joinCode)
            }
        
            #if os(iOS)
            .sheet(isPresented: $showScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "7A04A", completion: handleScan)
            }
            #endif
            Spacer()
        }
    }// end of view
    
    
    // Handle Scanning
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
    
    func createStudentAccount() {
        isLoading = true
        Task {
            do {
                try await viewModel.createStudent(withEmail: email, password: password, fullname: name, coursename: "", joincode: joinCode)
                navigatetoStudentDashboard = true
            } catch {
                print("Error signing in")
            }
            
            isLoading = false
        }
    }
    
}

struct JoinCodeTextField: View {
    @Binding var joinCode: String
    
    var body: some View {
        Text("Enter The Code Manually")
            .fontWeight(.semibold)
        Spacer()
            .frame(height: 20)
        TextField("Join Code", text: $joinCode)
            .padding(.all)
            .background()
            .cornerRadius(10.0)
    }
}

struct ScanQRCodeButton: View {
    @Binding var showScanner: Bool
    
    var body: some View {
        Button {
            showScanner = true
        } label: {
            Label("Or Scan A QR Code", systemImage: "qrcode.viewfinder")
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
        }
    }
}
