//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/11/26.
//

import Foundation
import Combine

@Observable
class ExpenseViewModel: ObservableObject {
    
    let defaults = UserDefaults(
        suiteName: "group.ismayil.expensetracker"
    )
    var totalExpense: Double
    
    init() {
        self.totalExpense = defaults?.double(forKey: "totalexpense") ?? 1000
    }
    
    
    func addExpense(expense: Double) {
        let defaults = UserDefaults(
            suiteName: "group.ismayil.expensetracker"
        )
        let value = defaults?.double(forKey: "totalexpense") ?? 1000
        totalExpense = value + expense
        defaults?.set(value+expense, forKey: "totalexpense")
    }
    
}
