//
//  HomeViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 08/07/26.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var dashboardData: DashboardData?
    
    func fetchDashboard() async {
//        await fetchAsync()
    }
    
    func fetchByOrder() async {
        let start = Date()
        let userDetails = await fetchUserDetails()
        let expenses = await fetchExpenses()
        let categories = await fetchCategories()
        self.dashboardData = DashboardData(expenses: expenses!, categories: categories!, userData: userDetails!)
        print("Total duration: \(Date().timeIntervalSince(start))")
    }
    
    func fetchAsync() async {
        let start = Date()
        async let userDetails = fetchUserDetails()
        async let expenses = fetchExpenses()
        async let categories = fetchCategories()
        
        self.dashboardData = await DashboardData(expenses: expenses!, categories: categories!, userData: userDetails!)
        print("Total duration: \(Date().timeIntervalSince(start))")
    }
    
    func fetchUserDetails() async -> UserDetails? {
        do {
            try await Task.sleep(for: .seconds(2))
            return UserDetails(id: 1, name: "Ismayil")
        } catch {
            return nil
        }
    }
    
    func fetchExpenses() async -> [ExpenseModel]? {
        do {
            try await Task.sleep(for: .seconds(5))
            return [ExpenseModel(title: "Spend at hotel", time: "Today", price: 20, category: .others),ExpenseModel(title: "Spend at hotel", time: "Today", price: 20, category: .others),ExpenseModel(title: "Spend at hotel", time: "Today", price: 20, category: .others),ExpenseModel(title: "Spend at hotel", time: "Today", price: 20, category: .others),ExpenseModel(title: "Spend at hotel", time: "Today", price: 20, category: .others)]
        } catch {
            return nil
        }
        
    }
    
    func fetchCategories() async -> [TransactionCategory]? {
        do {
            try await Task.sleep(for: .seconds(2))
            return [.entertainment,.groceries,.others,.shopping]
        } catch {
            return nil
        }
    }
}
