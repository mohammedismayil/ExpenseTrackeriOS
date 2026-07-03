//
//  TransactionDetailView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 02/07/26.
//

import SwiftUI

struct TransactionDetailView: View {
    var transaction: TransactionModel
    var body: some View {
        Text("Transaction detail: \(transaction.title)")
    }
}

#Preview {
    TransactionDetailView(transaction: TransactionModel(title: "", time: "", price: 22, percentage: "", category: .entertainment))
}
