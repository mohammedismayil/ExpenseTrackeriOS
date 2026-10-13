//
//  NavigationTestingDetailView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 13/10/26.
//

import SwiftUI

struct NavigationTestingDetailView: View {
    var user: String
    var body: some View {
        Text("NavigationTestingDetailView")
        Text("Selected User is \(user)")
    }
}

#Preview {
    NavigationTestingDetailView(user: "")
}
