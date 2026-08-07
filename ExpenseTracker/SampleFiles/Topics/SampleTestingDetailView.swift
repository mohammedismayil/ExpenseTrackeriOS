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
    @State var downloadTask: Task<Void, Never>?
    var body: some View {
        Text("Sample Testing Detail View: \(viewModel.name)")
            .onAppear {
//                Task.detached {
//                    print("Before:", Thread.isMainThread)
//                    await viewModel.mainActorExample()
//                    print("After:", Thread.isMainThread)
//                }
//                fetchUserUsingOldAsyncAPI()
//                Task {
//                    await fetchUserUsingContinuation()
//                }
                
//                dowloadUserImage()
                let sample = GCDSample()
                sample.checkConcurrentQueue()
                
            }
            .onDisappear(perform: {
                downloadTask?.cancel()
            })
//            .task {
//                await checkIsCancelledFlow()
//            }
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
    
    func fetchUserUsingOldAsyncAPI() {
        viewModel.fetchUserOldClosureAPI { (name) in
            print("Fetched using old api \(name)")
        }
    }
    
    func fetchUserUsingContinuation() async {
        let user = await viewModel.fetchUsingContinuation()
        print(user)
    }
    
    func dowloadUserImage() {
        downloadTask = Task {
            await downloadImage(id: "1")
        }
    }
    
    func downloadMultipleImages() async {
        print("Starting dowloading images")
        await withTaskGroup { group in
            for i in 0..<5 {
                if Task.isCancelled {
                    print("Parent cancelled")
                    break
                }
                group.addTask {
                    if Task.isCancelled {
                        print("Stopped")
                        return
                    }
                    let image = await downloadImage(id: i.description)
                }
            }
        }
    }
    
    func downloadImage(id: String) async -> String {
        print("Starting downloading image: \(id)")
        do {
            try await Task.sleep(for: .seconds(2))
            print("completed downloading image\(id)")
            return "Image"
        } catch is CancellationError {
            print("Cancelled downloading image\(id)")
            return "CancelledImage"
        } catch {
            print("error downloading image\(id)")
            return "ErrorImage"
        }
    }
    
    func checkIsCancelledFlow() async {
        
        downloadTask = Task {
            for i in 0..<100 {
                if Task.isCancelled {
                    print("Iam already cancelled")
                    return
                }
                print("Working \(i)")
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
//    SampleTestingDetailView()
}
