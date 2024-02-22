//
//  ClassCodeGeneration.swift
//  Teachers Pet
//
//  Created by Ashley Valdez on 2/21/24.
//

import SwiftUI

struct ClassJoinCodeGeneration: View {
    var body: some View {
        Text("Join Code")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        Text(generateCode())
        
       
    }
    func generateCode() -> String {
        let randomString = UUID().uuidString //0548CD07-7E2B-412B-AD69-5B2364644433
        let joinCode = randomString.replacingOccurrences(of: "-", with: "").prefix(5)
        
        return String(joinCode)
    }
}

#Preview {
    ClassJoinCodeGeneration()
}
