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
                Text("Welcome Back!").frame(maxWidth: .infinity, alignment: .leading).bold().font(.title2)
                Text(Date().formatted(.dateTime.month(.wide).day())).frame(maxWidth: .infinity, alignment: .leading).font(.title3)
                    .bold()
                
                VStack {
                    Text("Monthly budget").frame(maxWidth: .infinity, alignment: .leading).fontWeight(.semibold)
                    Text("$3200").bold().font(.system(size: 18))
                    Gauge(value: 0.3) {
                        
                    }
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text("Remaining").frame(maxWidth: .infinity, alignment: .leading)
                        })
                        VStack(alignment: .trailing, content: {
                            Text("72%").frame(maxWidth: .infinity, alignment: .trailing)
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
                        Text("5000")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical,10)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .fill(Color(.cyan))
                    )
                    VStack {
                        Text("Expense")
                        Text("2000")
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
struct TransactionModel: Identifiable, Hashable {
    let id: String
    
    let title: String
    let time: String
    let price: String
    let percentage: String
    init(title: String, time: String, price: String, percentage: String) {
        self.title = title
        self.time = time
        self.price = price
        self.percentage = percentage
        self.id = UUID().uuidString
    }
}
//#Preview {
//    HomeView()
//}
