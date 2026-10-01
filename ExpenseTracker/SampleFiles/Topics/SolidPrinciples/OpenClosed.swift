//
//  OpenClosed.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/10/26.
//

import Foundation
class PaymentService {
    func pay(method: String) {
        switch method {
        case "apple":
            print("apple")
        case "cash":
            print("cash")
        default:
            print("default")
        }
    }
}

protocol PaymentMethod {
    func pay()
}
class CashPayment: PaymentMethod {
    func pay() {
        print("Cash paid")
    }
}
class ApplePayment: PaymentMethod {
    func pay() {
        print("apple paid")
    }
}
class PaymentServiceOptimised {
    private let method: PaymentMethod
    func pay() {
        method.pay()
    }
    
    init(method: PaymentMethod) {
        self.method = method
    }
    
}
