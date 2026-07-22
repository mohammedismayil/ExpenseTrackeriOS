//
//  ProductsListViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 22/07/26.
//

import Foundation
import Combine
@MainActor
class ProductsListViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    
    func fetchProducts() {
        self.products = [ProductModel(id: 6, title: nil, description: nil),ProductModel(id: 1, title: nil, description: nil),ProductModel(id: 2, title: nil, description: nil),ProductModel(id: 3, title: nil, description: nil),ProductModel(id: 4, title: nil, description: nil),ProductModel(id: 5, title: nil, description: nil)]
    }
    
    func fetchProduct(id: Int) async {
        print("🔵 Started fetchProduct:", id)
        guard let url = URL(string: "https://dummyjson.com/products/\(id)") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let product = try decoder.decode(ProductModel.self, from: data)
            print("🟢 Finished fetchProduct:", id)
            if let index = products.firstIndex(where: { $0.id == product.id }) {
                products[index] = product
            }
        } catch {
            print("🔴 Cancelled fetchProduct:", id)
        }
    }
    
    func fetchAllProducts() async {
        let productIds = products.map { $0.id }
        await withTaskGroup(of: Void.self) { group in
            for id in productIds {
                group.addTask {
                    await self.fetchProduct(id: id)
                }
            }
        }
        
    }
}

struct ProductModel: Codable,Identifiable {
    let id: Int
    let title: String?
    let description: String?
}
