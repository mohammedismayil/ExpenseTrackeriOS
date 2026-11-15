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

struct MonthlyExpense: Identifiable {
    let id: String
    
    let month: String
    let amount: Double
}



struct ChartExample: View {
    let expenses: [Expense] = [.init(category: "Food", amount: 1000),.init(category: "Travel", amount: 300),.init(category: "Fuel", amount: 500)]
    
    let monthlyExpense: [MonthlyExpense] = [MonthlyExpense(id: "1", month: "Jan", amount: 18000),
        MonthlyExpense(id: "2", month: "Feb", amount: 22000),
        MonthlyExpense(id: "3",month: "Mar", amount: 19500),
        MonthlyExpense(id: "4",month: "Apr", amount: 25000),
        MonthlyExpense(id: "5",month: "May", amount: 21000)]
    
    var body: some View {
        ScrollView {
            VStack {
                barMarkChart
                lineMarkChart
                areaMarkChart
            }
           
        }
       
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
            LineMark(x: .value("Month", expense.month), y: .value("Amount", expense.amount)).interpolationMethod(.catmullRom)
            PointMark(x: .value("Month", expense.month), y: .value("Amount", expense.amount))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
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
        if #available(iOS 18, *) {
            return amount.formatted(.currency(code: "INR").notation(.compactName))
        } else {
            // Fallback on earlier versions
            return "\(amount)"
        }
    }
    
    
    @ViewBuilder
    var areaMarkChart: some View {
        Chart {
            ForEach(monthlyExpense) { expense in
                AreaMark(x: .value("Month", expense.month), y: .value("Amount", expense.amount)).foregroundStyle(LinearGradient(colors: [.green.opacity(0.5), .green.opacity(0.05)], startPoint: .top, endPoint: .bottom)).interpolationMethod(.catmullRom)
                LineMark(x: .value("Month", expense.month), y: .value("Amount", expense.amount)).interpolationMethod(.catmullRom).foregroundStyle(.green)
            }
            
            RuleMark(y: .value("Budget", 22000)).lineStyle(StrokeStyle(lineWidth: 1,dash: [10])).annotation(position: .top, alignment: .leading) {
                Text("Budget")
            }.foregroundStyle(.red)
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let month = value.as(String.self) {
                        Text(month)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text(getRoundedAmount(amount: amount))
                        }
                    }
                }
        }
    }
}

#Preview {
    ChartExample()
}
