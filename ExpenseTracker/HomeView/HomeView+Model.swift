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
    static let totalBudget = 10000
    static let totalExpense = 4000
    static let totalIncome = 1000
    static var balancePercentage: Float = Float(abs(Float((totalExpense - totalIncome)) / Float(totalBudget)))
    static let remaining = Int((1 - balancePercentage) * 100)
    
}
struct TransactionModel: Identifiable, Hashable {
    let id: String
    let title: String
    let time: String
    let price: String
    let percentage: String
    init(title: String, time: String, price: String, percentage: String) {
        self.title = title
        self.time = time
        self.price = price
        self.percentage = percentage
        self.id = UUID().uuidString
    }
}
