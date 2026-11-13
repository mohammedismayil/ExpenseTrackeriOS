//
//  ChartExample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 13/11/26.
//

import SwiftUI
import Charts

struct Expense {
    let category: String
    let amount: Double
}



struct ChartExample: View {
    let expenses: [Expense] = [.init(category: "Food", amount: 1000),.init(category: "Travel", amount: 300),.init(category: "Fuel", amount: 500)]
    var body: some View {
        barMarkChart
    }
    
    
    @ViewBuilder
    var barMarkChart: some View {
        Chart(expenses, id: \.category) { expense in
            BarMark(x: .value("a", expense.category), y: .value("a", expense.amount))
        }
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    ChartExample()
}
