//
//  SingleResponsibility.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/10/26.
//

import Foundation
class TransactionManager {
    func saveTransaction() {
        
    }
    
    func fetchTransaction() {
        
    }
    
    func uploadTransaction() {
        
    }
}

protocol TransactionAPI {
    func fetchTransaction()
}

class TransactionRepository {
    private let api: TransactionAPI
    
    init(api: TransactionAPI) {
        self.api = api
    }
    
    func fetchTransaction() {
        api.fetchTransaction()
    }
}

class TransactionDataHandler {
    func saveTransaction() {
        
    }
}
