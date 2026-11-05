//
//  ProductDetailView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import SwiftUI

struct EnvironmentalObjectProductDetailView: View {
    var viewModel: CartViewViewModel
    var body: some View {
        if viewModel.canShowCartView {
            CartView(vm: viewModel)
        } else {
            EmptyView()
        }
    }
}

#Preview {
//    EnvironmentalObjectProductDetailView()
}
