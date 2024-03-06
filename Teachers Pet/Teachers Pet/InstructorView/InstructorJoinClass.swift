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
    @Binding var email: String
    @Binding var password: String
    @Binding var name: String
    
    @State var joinCode = String()
    @State var navigateToDashBoard = false
    @State var showScanner = false
    @State var isLoading = false
    
    @EnvironmentObject var viewModel: AuthViewModel
       
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
                
                //Show loading indicator.
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Button {
                        isLoading = true
                        Task {
                            do {
                                try await viewModel.joinClassAsTA(joinCode: joinCode, Name: name, email: email)
                                navigateToDashBoard = true
                            } catch {
                                print("Error joining class")
                            }
                        }
                        
                    } label: {
                        Text("Join Class")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .controlSize(.large)
                    Spacer()
                    
                }
                
            } // end of VStack
            
            .padding()
            .background(appBackgroundColor)
            .preferredColorScheme(.light)
            #if os(iOS)
            .sheet(isPresented: $showScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "7A04A", completion: handleScan)
            }
            #endif
            .navigationDestination(isPresented: $navigateToDashBoard) {
                InstructorDashboard()
            }
            .onAppear {
                Task {
                    try await viewModel.createUser(withEmail:email, password: password, fullname: name, coursename: "", joincode: joinCode) //only first name for now fix this to have both
                }
            }
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
}

//#Preview {
//    InstructorJoinClass()
//}
