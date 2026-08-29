//
//  CartView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import SwiftUI
struct CartScreenView: View {
    @EnvironmentObject var viewModel: CartViewViewModel
    var body: some View {
        CartView()
    }
}
struct CartView: View {
    @EnvironmentObject var viewModel: CartViewViewModel
    var body: some View {
        HStack {
            Button("+") {
                viewModel.increment()
            }
            Text("\(viewModel.count)")
            Button("-") {
                viewModel.decrement()
            }
        }
        
    }
}

#Preview {
    CartScreenView()
}
