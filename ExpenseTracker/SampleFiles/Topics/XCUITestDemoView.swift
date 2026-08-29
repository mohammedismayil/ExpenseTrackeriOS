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
    @Environment(\.scenePhase) private var scenePhase
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
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                        
                    case .background:
                        print("App gone to background in XCUITestDemoView")
                    case .inactive:
                        print("App gone to Inactive XCUITestDemoView")
                    case .active:
                        print("App gone to active XCUITestDemoView")
                    @unknown default:
                        print("Default state on appstate change")
                    }
                }
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
