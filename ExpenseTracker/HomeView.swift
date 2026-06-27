//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/06/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("Welcome Back!").frame(maxWidth: .infinity, alignment: .leading).bold().font(.title2)
            Text(Date().formatted(.dateTime.month(.wide).day())).frame(maxWidth: .infinity, alignment: .leading).font(.title3)
                .bold()
            
            VStack {
                Text("Monthly budget").frame(maxWidth: .infinity, alignment: .leading).fontWeight(.semibold)
                Text("$3200").bold().font(.system(size: 18))
                Gauge(value: 0.3) {
                    
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
                        RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                            .fill(Color(.cyan))
                    )
            }.padding(.vertical, 12)
        }).padding(.horizontal, 14)
    }
}

#Preview {
    HomeView()
}
