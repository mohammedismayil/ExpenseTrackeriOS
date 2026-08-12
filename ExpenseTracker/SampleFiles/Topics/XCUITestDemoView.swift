//
//  XCUITestDemoView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 12/08/26.
//

import SwiftUI

struct XCUITestDemoView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var loggedIn: Bool = false
    var body: some View {
        if loggedIn {
            Text("User loggedin").accessibilityLabel("home")
        } else {
            TextField("Username", text: $username).accessibilityValue("username")
            SecureField("Username", text: $password).accessibilityValue("password")
            PropertyObserverExampleView()
            Button("Signin") {
                signIn()
            }.accessibilityLabel("signinAction")
        }
        
    }
    
    func signIn() {
        if password.lowercased() == "admin123" &&  username.lowercased() == "admin" {
            loggedIn = true
        } else {
            loggedIn = false
        }
    }
}

#Preview {
    XCUITestDemoView()
}
