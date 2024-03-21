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
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var joinCodeisvalid = false
    @State var navigatetoStudentSignIn = false
    
    
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
                        checkIfJoinCodeIsValidAndCreateAccount()
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton:  .default(Text("Sign In"), action: {
                        navigatetoStudentSignIn = true
                    }),
                    secondaryButton: .default(Text("OK"))
                )
            }
            
            
            
            .navigationDestination(isPresented: $navigatetoStudentSignIn) {
                SignIn(isStudent: .constant(true), isInstructor: .constant(false))
            }
            
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
    
    func checkIfJoinCodeIsValidAndCreateAccount() {
        isLoading = true
        Task {
            do {
                let joinCodedoesnotexist = try await viewModel.canjoinClass(joinCode: joinCode)
                if joinCodedoesnotexist {
                    showAlert = true
                    alertTitle = "Incorrect."
                    alertMessage = "Invalid join code."
                    isLoading = false
                    return
                }
                
                try await viewModel.createStudent(withEmail: email, password: password, fullname: name, coursename: "", joincode: joinCode)
                navigatetoStudentDashboard = true
            } catch {
                showAlert = true
                alertTitle = "Existing Account Detected."
                alertMessage = "Please sign into your account"
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
