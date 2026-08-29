//
//  ProductDetailView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import SwiftUI

struct EnvironmentalObjectProductDetailView: View {
    @EnvironmentObject var viewModel: CartViewViewModel
    var body: some View {
        if viewModel.count > 0 {
            CartView()
        } else {
            EmptyView()
        }
    }
}

#Preview {
    EnvironmentalObjectProductDetailView()
}
