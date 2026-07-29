//
//  Zombies.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/07/26.
//

import Foundation
import Combine

class ZombieParent: NSObject {
    var child: ZombieChild?
    unowned var dog: ZombieDog?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class ZombieChild: NSObject {
    var name: String
    var parent: ZombieParent?
    
    init(name: String) {
        self.name = name
    }
    
    func run() {
        print("\(name) is running")
    }
}

class ZombieDog: NSObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func bark() {
        print("\(name) barking...")
    }
}
class SampleTestingDetailViewModel : ObservableObject {
    
    @Published var name: String = "Initial name"
    @Published var service: DummyAPIService = DummyAPIService()
   
    
    deinit {
        print("SampleTestingDetailViewModel deallocated")
    }
    
    func zombieExample() {
        service.fetchDelayedUser { [unowned self] in
            self.name = "zombie"
        }
    }
    
    func leakExample() {
        service.fetchUser {
            self.name = "zombie"
        }
    }
    
    
    
}
class DummyAPIService {
    var callBack: (() -> Void)?
    
    deinit {
        print("DummyAPIService deallocated")
    }
    
    func fetchUser(closure: @escaping () ->Void) {
        self.callBack = closure
    }
    
    func fetchDelayedUser(closure: @escaping () ->Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+4) {
            closure()
        }
    }
}
