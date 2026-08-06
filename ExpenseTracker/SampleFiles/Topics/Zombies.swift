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

@MainActor
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
    
    func weakExample() {
        service.fetchDelayedUserInMainThread { [weak self] in
            self?.name = "Iwillkillmyself"
        }
    }
    
    func mainActorExample() {
        print("Inside:", Thread.isMainThread)
        self.name = "jack"
    }
    
    func fetchUserOldClosureAPI(closure: @escaping (String) -> ()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            closure("UserA")
        })
    }
    
    func fetchUsingContinuation() async -> String {
        await withCheckedContinuation { contiuation in
            fetchUserOldClosureAPI { name in
                contiuation.resume(returning: name)
            }
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
    
    func fetchDelayedUserInMainThread(closure: @escaping () ->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            closure()
        }
    }
}
