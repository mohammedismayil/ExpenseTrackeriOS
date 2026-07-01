//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/06/26.
//

import SwiftUI

struct HomeView: View {
    var transactions: [TransactionModel] = [TransactionModel(title: "Coffee Shop", time: "Today,9:30", price: "5$", percentage: "1"),TransactionModel(title: "Electric bill", time: "Yesterday,9:30", price: "10$", percentage: "3"),TransactionModel(title: "Shopping", time: "Today,9:30", price: "5$", percentage: "1"),TransactionModel(title: "Groceries", time: "Today,9:30", price: "5$", percentage: "1"),TransactionModel(title: "Petrol bill", time: "Today,9:30", price: "5$", percentage: "1"),TransactionModel(title: "Trip bill", time: "Today,9:30", price: "5$", percentage: "1")]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, content: {
                Text("Welcome back \(HomeViewData.userName)!").frame(maxWidth: .infinity, alignment: .leading).bold().font(.title2)
                Text(HomeViewData.currentDate).frame(maxWidth: .infinity, alignment: .leading).font(.title3)
                
                VStack {
                    Text("Monthly budget").frame(maxWidth: .infinity, alignment: .leading).fontWeight(.semibold)
                    Text("$\(HomeViewData.totalBudget)").bold().font(.system(size: 18))
                    Gauge(value: HomeViewData.balancePercentage) {
                        
                    }
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text("Remaining").frame(maxWidth: .infinity, alignment: .leading)
                        })
                        VStack(alignment: .trailing, content: {
                            Text("\(HomeViewData.remaining)%").frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                )
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
                
                
                HStack(spacing: 16) {
                    VStack {
                        Text("Income")
                        Text(HomeViewData.totalIncome.description)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical,10)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .fill(Color(.cyan))
                    )
                    VStack {
                        Text("Expense")
                        Text(HomeViewData.totalExpense.description)
                    }.frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical,10)
                        .background(
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .fill(Color(.brown))
                        )
                }.padding(.vertical, 12)
                Text("Recent transactions").bold()
                VStack {
                    ForEach(Array(transactions.enumerated()), id: \.offset) { index, transaction in
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                            VStack {
                                Text(transaction.title).bold()
                                Text(transaction.time)
                            }.frame(maxWidth: .infinity)
                            VStack(alignment: .trailing, content: {
                                Text(transaction.price).bold()
                                Text(transaction.percentage)
                            }).frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        if index != transactions.count - 1 {
                            Divider()
                        }
                    }
                    
                   
                }.padding(.all,12)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                    
            }).padding(.horizontal, 14)
        }.background(Color(.systemGroupedBackground))

    }
}
#Preview {
    HomeView()
}
