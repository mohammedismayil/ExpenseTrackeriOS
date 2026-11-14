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

struct MonthlyExpense {
    let month: String
    let amount: Double
}



struct ChartExample: View {
    let expenses: [Expense] = [.init(category: "Food", amount: 1000),.init(category: "Travel", amount: 300),.init(category: "Fuel", amount: 500)]
    
    let monthlyExpense: [MonthlyExpense] = [MonthlyExpense(month: "Jan", amount: 18000),
        MonthlyExpense(month: "Feb", amount: 22000),
        MonthlyExpense(month: "Mar", amount: 19500),
        MonthlyExpense(month: "Apr", amount: 25000),
        MonthlyExpense(month: "May", amount: 21000)]
    
    var body: some View {
        barMarkChart
        lineMarkChart
    }
    
    
    @ViewBuilder
    var barMarkChart: some View {
        Chart(expenses, id: \.category) { expense in
            BarMark(x: .value("Category", expense.category), y: .value("Amount", expense.amount))//.foregroundStyle(by: .value("Category", expense.category))
        }
        .chartXAxis {
            AxisMarks()
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .frame(height: 300)
        .padding()
    }
    
    @ViewBuilder
    var lineMarkChart: some View {
        Chart(monthlyExpense, id: \.month) { expense in
            LineMark(x: .value("Month", expense.month), y: .value("Amount", expense.amount))
            PointMark(x: .value("Month", expense.month), y: .value("Amount", expense.amount))
        }
        .chartXAxis {
            
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                                    Text(getRoundedAmount(amount: amount))
                                }
                }
            }
        }
        .foregroundStyle(.green)
        .frame(height: 300)
        .padding()
    }
    
    func getRoundedAmount(amount: Double) -> String {
        return "₹\(amount/1000)K"
    }
}

#Preview {
    ChartExample()
}
