//
//  CartViewViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import Foundation
import Combine
import SwiftUI

class CartViewViewModel: ObservableObject {
    @Published var count: Int = 0
    
    func increment() {
        self.count += 1
    }
    
    func decrement() {
        if count > 0 {
            count -= 1
        }
    }
}
