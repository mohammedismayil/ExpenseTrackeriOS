//
//  SampleTestingDetailView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/07/26.
//

import SwiftUI

struct SampleTestingDetailView: View {
    @State var child: ZombieChild?
    @State var parent: ZombieParent?
    @State var name: String
    @StateObject var viewModel = SampleTestingDetailViewModel()
    var body: some View {
        Text("Sample Testing Detail View: \(viewModel.name)")
            .onAppear {
                Task.detached {
                    print("Before:", Thread.isMainThread)
                    await viewModel.mainActorExample()
                    print("After:", Thread.isMainThread)
                }
               
            }
    }
    
    func memoryLeakExample() {
        child = ZombieChild(name: "child")
        parent = ZombieParent(name: "Parent")
        child?.parent = parent
        parent?.child = child
        child = nil
        parent = nil
    }
    
    func zombieExample() {
        viewModel.zombieExample()
    }
    
    func leakExample() {
        viewModel.leakExample()
    }
    
    func actorsClassExample() {
        let counter = CounterClass()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            for _ in 0..<10_000 {
                counter.increment()
            }
            group.leave()
        }
        group.enter()
        DispatchQueue.global().async {
            for _ in 0..<10_000 {
                counter.increment()
            }
            group.leave()
        }
        group.wait()
        print(counter.count)
    }
    
    func actorsExample() async {
        let counter = CounterActor()
        await withTaskGroup { group in
            group.addTask {
                for _ in 0..<10_000 {
                    await counter.increment()
                }
            }
            group.addTask {
                for _ in 0..<10_000 {
                    await counter.increment()
                }
            }
            
        }
        print(await counter.count)
        
    }
}

#Preview {
//    SampleTestingDetailView()
}
