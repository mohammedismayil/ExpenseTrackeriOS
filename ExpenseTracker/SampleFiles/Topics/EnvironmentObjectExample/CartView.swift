//
//  CartView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import SwiftUI
struct CartScreenView: View {
    var viewModel: CartViewViewModel
    var body: some View {
        CartView(vm: viewModel)
    }
}
struct CartView<VM: CartViewModelProtocol>: View {
    let vm: VM
    var body: some View {
        HStack {
            Button("+") {
                vm.incrementButtonTapped()
            }
            Text("\(vm.countText)")
            Button("-") {
                vm.decrementButtonTapped()
            }
        }
        
    }
}

struct CartViewRoute: View {
    @State var viewModel: CartViewViewModel = CartViewViewModel()
    var body: some View {
        CartView(vm: viewModel)
    }
}

#Preview {
//    CartScreenView()
}
