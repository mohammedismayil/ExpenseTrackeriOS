//
//  ActorsBasicsView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/11/26.
//

import SwiftUI

@Observable
class BankAccount {
    private var balance: Int
    
    init(balance: Int) {
        self.balance = balance
    }
    
    func deposit(amount: Int) {
        balance += amount
    }
    
    func withDraw(amount: Int) async -> Int {
        
        if balance < amount {
            print("you have low balance")
            return balance
        }
        try? await Task.sleep(for: .seconds(1))
        balance -= amount
        return balance
    }
    
    func getBalance() -> Int {
        return balance
    }

}

struct ActorsBasicsView: View {
    let account = BankAccount(balance: 100)
    var body: some View {
        Text(account.getBalance(),format: .currency(code: "INR")).contentTransition(.numericText())
        Button("Class Banker") {
            for _ in 0..<100 {
                Task {
                    await account.withDraw(amount: 100)
                }
                
            }
            
        }
        
        Button("Deposit Class Banker") {
            depositToUsualBanker()
        }
    }
    
    func depositToUsualBanker() {
        account.deposit(amount: 100)
    }
    
    func testUsualBanker() async {
        await withDraw()
    }
    
    func withDraw() async {
        await account.withDraw(amount: 100)
    }
}

#Preview {
    ActorsBasicsView()
}
