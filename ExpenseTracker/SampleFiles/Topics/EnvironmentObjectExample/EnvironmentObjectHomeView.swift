//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import SwiftUI

struct EnvironmentObjectHomeView: View {
    @EnvironmentObject var viewModel: CartViewViewModel
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            if viewModel.count > 0 {
                CartView()
            } else {
                EmptyView()
            }
        }
            .navigationTitle("Home")
    }
}

#Preview {
    EnvironmentObjectHomeView()
}
