//
//  LoggedInUserView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 04/07/26.
//

import SwiftUI

struct LoggedInUserView: View {
    var body: some View {
        Text("Logged In User IAM")
        Button("Logout") {
            LoginViewModel.logout()
        }.buttonStyle(.glassProminent)
    }
}

#Preview {
    LoggedInUserView()
}
