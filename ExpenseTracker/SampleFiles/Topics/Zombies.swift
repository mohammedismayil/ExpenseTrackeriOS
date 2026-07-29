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
    
   
    
    deinit {
        print("SampleTestingDetailViewModel deallocated")
    }
    
    func zombieExample() {
//        let service: DummyAPIService = DummyAPIService()
//        service.fetchUser { [weak self] in
//            self?.name = "zombie"
//        }
    }
    
    
    
}
class DummyAPIService {
    func fetchUser(closure: @escaping () ->Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            closure()
        }
    }
}
