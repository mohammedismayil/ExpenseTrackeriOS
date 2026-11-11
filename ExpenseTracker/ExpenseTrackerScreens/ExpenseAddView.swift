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
        Picker("", selection: $selectionType) {
            Text("Expense").tag("Expense")
            Text("Income").tag("Income")
        }.pickerStyle(.segmented).padding(.horizontal)
        
        
        TextField("Expense", value: $expense, format: .number)
        
        Button("Add"){
            viewModel.addExpense(expense: expense)
        }
    }
}

#Preview {
    ExpenseAddView()
}
