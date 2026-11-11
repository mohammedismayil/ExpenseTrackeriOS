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
    var totalExpense: Double {
        let defaults = UserDefaults(
            suiteName: "group.ismayil.expensetracker"
        )
        let expense = defaults?.double(forKey: "totalexpense") ?? 2000
        return expense
    }
    
    
    func addExpense(expense: Double) {
        let defaults = UserDefaults(
            suiteName: "group.ismayil.expensetracker"
        )
        let value = defaults?.double(forKey: "totalexpense") ?? 1000
        defaults?.set(value+expense, forKey: "totalexpense")
    }
    
}
