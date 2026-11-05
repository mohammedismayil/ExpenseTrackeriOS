//
//  CartViewViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/08/26.
//

import Foundation
import Combine
import SwiftUI

//Contract Model
@MainActor
protocol CartViewModelProtocol: ObservableObject {
    var countText: String { get }
    var canShowCartView: Bool { get }
    func incrementButtonTapped()
    func decrementButtonTapped()
}

@Observable
class CartViewViewModel: CartViewModelProtocol {
    private var count = 0
    
    var countText: String {
        return String(count)
    }
    
    var canShowCartView: Bool {
        if count > 0 {
            return true
        }
        return false
    }
    
    func incrementButtonTapped() {
        count += 1
    }
    
    func decrementButtonTapped() {
        count -= 1
    }
    
    
}
