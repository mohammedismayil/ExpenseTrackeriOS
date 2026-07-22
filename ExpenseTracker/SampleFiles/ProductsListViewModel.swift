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
    
    func fetchProduct(id: Int) async -> ProductModel? {
        print("🔵 Started fetchProduct:", id)
        guard let url = URL(string: "https://dummyjson.com/products/\(id)") else { return  nil}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let product = try decoder.decode(ProductModel.self, from: data)
            print("🟢 Finished fetchProduct:", id)
            return product
        } catch {
            print("🔴 Cancelled fetchProduct:", id)
            return nil
        }
    }
    
    func fetchAllProducts() async {
        let productIds = products.map { $0.id }
        await withTaskGroup(of: ProductModel?.self) { group in
            for id in productIds {
                group.addTask {
                    await self.fetchProduct(id: id)
                }
            }
            for await product in group {
                if let id = product?.id, let productIndex = products.firstIndex(where: {$0.id == id}), let product = product {
                    products[productIndex] = product
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
