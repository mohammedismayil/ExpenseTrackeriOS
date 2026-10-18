//
//  AsyncFundamentals.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 17/10/26.
//

import Foundation
class AsyncFundamentals {
    func getUserData() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            return "User"
        }
//        catch {
//            print("\(error) catched on getUserData")
//        }
//        return ""
    }
    
    func getStatData() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(3))
            return "Stat"
        }
//        catch {
//            print("\(error) catched on getStatData")
//        }
//        return ""
    }
    
    func getMainData() async throws -> String {
        do {
            try await Task.sleep(for: .seconds(1))
            return "Main"
        }
//        catch {
//            print("\(error) catched on getMainData")
//        }
//        return ""
    }
}
