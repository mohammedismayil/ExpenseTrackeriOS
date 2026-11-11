//
//  ExpenseAddView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/11/26.
//

import SwiftUI

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
            Button("Add"){
                viewModel.addExpense(expense: expense)
            }
            Spacer()
        }.navigationTitle("Add expense")
    }
}

extension Color {
    static let expenseGreen = Color(
        red: 40 / 255,
        green: 92 / 255,
        blue: 69 / 255
    )
}

#Preview {
    ExpenseAddView()
}
