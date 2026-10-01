//
//  InterfaceSegregation.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/10/26.
//

import Foundation
protocol HugeUserService {
    func fetchUser()
    func updateUser()
    func saveUser()
}

class SampleUserFetch: HugeUserService {
    func fetchUser() {
        print("fetcu user")
    }
    
    func updateUser() {
        print("no need")
    }
    
    func saveUser() {
        print("no need")
    }
}

protocol FetchUserService {
    func fetch()
}

class OptimisedUserFetch: FetchUserService {
    func fetch() {
        print("fetcu user")
    }
}
