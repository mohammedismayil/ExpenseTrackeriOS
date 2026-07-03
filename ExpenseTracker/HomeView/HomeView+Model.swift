//
//  HomeView+Model.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/07/26.
//

import Foundation
struct HomeViewData {
    static let userName = "Ismayil"
    static let currentDate = Date().formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    static let currentCurrencyCode = "$"
    static let totalBudget = 10000
    static let totalExpense = 4000
    static let totalIncome = 1000
    static var balancePercentage: Float = Float(abs(Float((totalExpense - totalIncome)) / Float(totalBudget)))
    static let remaining = Int((1 - balancePercentage) * 100)
    static var transactions: [TransactionModel] = [TransactionModel(title: "Coffee Shop", time: "Today,9:30", price: 5, percentage: "1", category: .groceries),TransactionModel(title: "Electric bill", time: "Yesterday,9:30", price: 10, percentage: "3", category: .utilities),TransactionModel(title: "Shopping", time: "Today,9:30", price: 100, percentage: "1", category: .shopping),TransactionModel(title: "Groceries", time: "Today,9:30", price: 50, percentage: "1", category: .groceries),TransactionModel(title: "Petrol bill", time: "Today,9:30", price: 50, percentage: "1", category: .utilities),TransactionModel(title: "Trip bill", time: "Today,9:30", price: 75, percentage: "1", category: .utilities)]
    
}
struct TransactionModel: Identifiable, Hashable {
    let id: String
    let title: String?
    let time: String
    let price: Int64
    let percentage: String
    let category: TransactionCategory
    init(title: String?, time: String, price: Int64, percentage: String, category: TransactionCategory) {
        self.title = title
        self.time = time
        self.price = price
        self.percentage = percentage
        self.category = category
        self.id = UUID().uuidString
    }
}

enum TransactionCategory: String {
    case groceries
    case utilities
    case transport
    case entertainment
    case shopping
    case others
    
    var icon: String {
        switch self {
        case .groceries:
            return "carrot.fill"
        case .utilities:
            return "takeoutbag.and.cup.and.straw.fill"
        case .transport:
            return "bus.fill"
        case .entertainment:
            return "music.note"
        case .shopping:
            return "bag.fill"
        case .others:
            return "square.on.circle.fill"
        }
    }
}
