//
//  ActorsBasicsView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/11/26.
//

import SwiftUI
import Combine

@Observable
class BankAccount {
    private var balance: Int
    
    init(balance: Int) {
        self.balance = balance
    }
    
    func deposit(amount: Int) {
        balance += amount
    }
    
    func withDraw(amount: Int) ->  Int {
        
        if balance < amount {
            print("you have low balance")
            return balance
        }
        Thread.sleep(forTimeInterval: 0.1)
        balance -= amount
        return balance
    }
    
    func getBalance() -> Int {
        return balance
    }

}

actor ModernBankAccount {
    private var balance: Int
    
    init(balance: Int) {
        self.balance = balance
    }
    
    func deposit(amount: Int) {
        balance += amount
    }
    
    func withDraw(amount: Int) async ->  Int {
        
        if balance < amount {
            print("you have low balance")
            return balance
        }
        Thread.sleep(forTimeInterval: 0.1)
        balance -= amount
        return balance
    }
    
    func getBalance() -> Int {
        return balance
    }

}

struct ActorsBasicsView: View {
    let classAccount = BankAccount(balance: 100)
    let modernAccount = ModernBankAccount(balance: 100)
    
    var body: some View {
        Text(classAccount.getBalance(),format: .currency(code: "INR")).contentTransition(.numericText())
        
        Text(modernAccount.getBalance(),format: .currency(code: "INR")).contentTransition(.numericText())
        Button("Class Banker") {
            for _ in 0..<100 {
                DispatchQueue.global().async {
                        classAccount.withDraw(amount: 100)
                    }
            }
        }
        
        Button("Actor Banker") {
            for _ in 0..<100 {
                Task {
                    await modernAccount.withDraw(amount: 100)
                }
            }
            
            print(modernAccount.getBalance())
        }
        
        Button("Deposit Class Banker") {
            depositToUsualBanker()
        }
        
        Button("Get balance") {
            print("Classic balance: \(classAccount.getBalance())")
            print("Modern balance: \(modernAccount.getBalance())")
        }
    }
    
    func depositToUsualBanker() {
        classAccount.deposit(amount: 100)
    }
  
    
}

#Preview {
    ActorsBasicsView()
}
