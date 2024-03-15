//
//  InstructorJoinClass.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/28/24.
//

import SwiftUI
#if canImport(CodeScanner)
import CodeScanner
#endif

struct InstructorJoinClass: View {
    //User Account Information Binding/State Variables
    @Binding var email: String
    @Binding var password: String
    @Binding var name: String
    @State var joinCode = String()
    
    //Navigation & View Toggle State Variables
    @State var navigateToDashBoard = false
    @State var showScanner = false
    @State var isLoading = false
    
    @EnvironmentObject var viewModel: AuthViewModel
       
    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter Class Join Code")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(height: 60)
                JoinCodeEntry(joinCode: $joinCode)
                Spacer()
                    .frame(height: 50)
                
                #if os(iOS)
                ScanQRCode(showScanner: $showScanner)
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
                        createTAAccount()
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
            .navigationDestination(isPresented: $navigateToDashBoard) {
                InstructorDashboard()
            }
            
            #if os(iOS)
            .sheet(isPresented: $showScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "7A04A", completion: handleScan)
            }
            #endif
            Spacer()
        }// end of view
    }
    
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
    
    func createTAAccount() {
        isLoading = true
        Task {
            do {
                try await viewModel.createTA(withEmail: email, password: password, fullname: name, joincode: joinCode)
                navigateToDashBoard = true
            } catch {
                print("Error joining class")
            }
            
            isLoading = false
        }
    }
    
}

struct JoinCodeEntry: View {
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

struct ScanQRCode: View {
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
