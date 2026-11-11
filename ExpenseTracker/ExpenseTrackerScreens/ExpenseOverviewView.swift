//
//  ExpenseOverviewView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/11/26.
//

import SwiftUI
import Combine

struct ExpenseOverviewView: View {
    @State var isAddExpenseTapped: Bool = false
    var viewModel: ExpenseViewModel = ExpenseViewModel()
    var body: some View {
        NavigationStack {
            Text("Your money at a glance")
            Text("Overview")
            Text(viewModel.totalExpense.description).font(.largeTitle)
            Button("+") {
                isAddExpenseTapped = true
            }.navigationDestination(isPresented: $isAddExpenseTapped) {
                ExpenseAddView().environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ExpenseOverviewView()
}
