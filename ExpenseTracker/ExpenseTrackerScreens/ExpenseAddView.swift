//
//  ExpenseAddView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/11/26.
//

import SwiftUI

import Charts


struct ExpenseAddView: View {
    @State var selectionType: String = "Expense"
    @State var expense: Double = 0
    @EnvironmentObject var viewModel: ExpenseViewModel
    var body: some View {
        VStack {
            Picker("", selection: $selectionType) {
                Text("Expense")
                    .tag("Expense")

                Text("Income")
                    .tag("Income")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 30)
            .frame(width: 300, height: 35)
            .tint(.expenseGreen)
            HStack(alignment: .center) {
                TextField("Expense", value: $expense, format: .number).padding(.horizontal).font(.system(size: 58).weight(.semibold)).multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
            }
            .padding(.horizontal)
            .padding(.top, 30)
            TotalSpentCard().padding(.horizontal,20)
            Button("Add"){
                viewModel.addExpense(expense: expense)
            }
            Spacer()
        }.navigationTitle("Add expense")
    }
}

struct TotalSpentCard: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10, content: {
                HStack {
                    Text("Total spent").foregroundStyle(.white)
                    Spacer()
                    HStack(spacing: 10) {
                        Text("December")
                            .foregroundStyle(.white)

                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background {
                        Capsule()
                            .fill(Color.monthChipBackground)
                    }
                    .overlay {
                        Capsule()
                            .stroke(.black, lineWidth: 1)
                    }
                }
                HStack {
                    Text("$2000")
                        .foregroundStyle(.white)
                        .font(.system(size: 44, weight: .bold))
                    Spacer()
                }
                
                ComparisonChip(percentage: "12.78", month: "OCT")
                WeeklyExpenseChart()
            })
            .padding(.horizontal,22)
            .padding(.vertical,22)
        }
        .background(Color.expenseGreen)
        .cornerRadius(28)
    }
}
extension Color {
    static let expenseGreen = Color(
        red: 40 / 255,
        green: 92 / 255,
        blue: 69 / 255
    )
    
    static let monthChipBackground = Color(
        red: 59 / 255,
        green: 107 / 255,
        blue: 83 / 255
    )
    
    static let chartBar =
           Color(
               red: 124 / 255,
               green: 166 / 255,
               blue: 133 / 255
           )

       static let chartHighlight =
           Color(
               red: 214 / 255,
               green: 247 / 255,
               blue: 143 / 255
           )
}

struct ComparisonChip: View {
    let percentage: String
    let month: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "arrow.down.right")
                .font(.system(size: 16, weight: .semibold))

            Text("\(percentage) less than \(month)")
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(Color.monthChipBackground)
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background {
            Capsule()
                .fill(Color(red: 220 / 255,
                            green: 239 / 255,
                            blue: 197 / 255))
        }
    }
}

struct DayExpense: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}

struct WeeklyExpenseChart: View {

    let data = [
        DayExpense(day: "5", amount: 40),
        DayExpense(day: "6", amount: 65),
        DayExpense(day: "7", amount: 48),
        DayExpense(day: "8", amount: 85),
        DayExpense(day: "9", amount: 58),
        DayExpense(day: "10", amount: 100),
        DayExpense(day: "11", amount: 70)
    ]

    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Day", item.day),
                y: .value("Expense", item.amount)
            )
            .foregroundStyle(
                item.day == "11"
                    ? Color.chartHighlight
                    : Color.chartBar
            )
            .cornerRadius(10)
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .chartYAxis(.hidden)
        .chartPlotStyle { plotArea in
            plotArea
                .background(.clear)
        }
        .frame(height: 180)
    }
}

#Preview {
    ExpenseAddView()
}
