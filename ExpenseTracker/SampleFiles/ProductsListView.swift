//
//  ProductsListView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 22/07/26.
//

import SwiftUI

struct ProductsListView: View {
    @StateObject var viewModel = ProductsListViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.products) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        if let title = product.title {
                            Text(title)
                        } else {
                            ProgressView()
                        }
                        
                    }

                    
                }
            }.task {
                viewModel.fetchProducts()
                await viewModel.fetchAllProducts()
            }
        }
        
    }
}

struct ProductDetailView: View {
    var product: ProductModel
    var body: some View {
        Text(product.title ?? "")
    }
}

#Preview {
    ProductsListView()
}
