//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 04/07/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    var body: some View {
        Text("Login screen")
        VStack {
            TextField("Email", text: $loginViewModel.email)
            SecureField("Password", text: $loginViewModel.password)
            if loginViewModel.isLoading {
                ProgressView()
            }
            if loginViewModel.isError {
                Text("Credentials wrong")
            }
            Button("Login") {
                Task {
                    await loginViewModel.login()
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    LoginView()
}
