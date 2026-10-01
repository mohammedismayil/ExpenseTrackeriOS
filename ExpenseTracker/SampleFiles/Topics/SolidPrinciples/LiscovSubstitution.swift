//
//  LiscovSubstitution.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/10/26.
//

import Foundation

class PaymentMethodLegacy {
    func cashOnDelivery() {
        print("Cash on delivery")
    }
    
    func returnOrder() {
        print("I am returning the order")
    }
    
    func cancelOrder() {
        print("Cancelling order")
    }
}

class OfferPayment: PaymentMethodLegacy {
    override func cashOnDelivery() {
        fatalError("cash on delivery not possible on this payment")
    }
}

protocol CashOnDeliveryProtocol {
    func cashOnDelivery()
}
protocol DeliveryProtocol {
    func returnOrder()
    func cancelOrder()
}
class OfferPaymentLatest: DeliveryProtocol {
    func returnOrder() {
        
    }
    
    func cancelOrder() {
        
    }
    
    
}
