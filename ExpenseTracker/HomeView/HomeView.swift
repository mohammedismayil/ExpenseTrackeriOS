//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/06/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, content: {
                    Text("Welcome back \(HomeViewData.userName)!").frame(maxWidth: .infinity, alignment: .leading).bold().font(.title2)
                    Text(HomeViewData.currentDate).frame(maxWidth: .infinity, alignment: .leading).font(.title3)
                    
                    VStack {
                        Text("Monthly budget").frame(maxWidth: .infinity, alignment: .leading).fontWeight(.semibold)
                        Text("\(HomeViewData.currentCurrencyCode)\(HomeViewData.totalBudget)").bold().font(.system(size: 18))
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
                            Text("\(HomeViewData.currentCurrencyCode)\(HomeViewData.totalIncome)")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical,10)
                        .background(
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .fill(Color(.cyan))
                        )
                        VStack {
                            Text("Expense")
                            Text("\(HomeViewData.currentCurrencyCode)\(HomeViewData.totalExpense)")
                        }.frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical,10)
                            .background(
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .fill(Color(.brown))
                            )
                    }.padding(.vertical, 12)
                    Text("Recent transactions").bold()
                    VStack {
                        ForEach(Array(HomeViewData.transactions.enumerated()), id: \.offset) { index, transaction in
                            
                            NavigationLink {
                                TransactionDetailView(transaction: transaction)
                            } label: {
                                HStack {
                                    Image(systemName: transaction.category.icon).frame(minWidth: 25)
                                    VStack {
                                        Text(transaction.title ?? transaction.category.rawValue.capitalized).bold().frame(maxWidth: .infinity, alignment: .leading)
                                        Text(transaction.time).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading,10)
                                    VStack(alignment: .trailing, content: {
                                        Text("\(HomeViewData.currentCurrencyCode)\(transaction.price)").bold()
                                        Text(transaction.percentage)
                                    }).frame(maxWidth: .infinity, alignment: .trailing)
                                }.contentShape(Rectangle())
                                if index != HomeViewData.transactions.count - 1 {
                                    Divider()
                                }
                                
                            }.buttonStyle(PlainButtonStyle())

                        }
                    }.padding(.all,16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                        
                }).padding(.horizontal, 14)
            }.background(Color(.systemGroupedBackground))
        }

    }
}
#Preview {
    HomeView()
}
