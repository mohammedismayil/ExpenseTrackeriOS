//
//  AsyncFundamentals.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 17/10/26.
//

import Foundation
class AsyncFundamentals {
    func getUserData() async throws -> String {
        try await Task.sleep(for: .seconds(3))
        return "User"
    }
    
    func getStatData() async throws -> String {
        try await Task.sleep(for: .seconds(3))
        return "Stat"
    }
    
    func getMainData() async throws -> String {
        try await Task.sleep(for: .seconds(3))
        return "Main"
    }
}
