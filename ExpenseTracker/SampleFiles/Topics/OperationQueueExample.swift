//
//  OperationQueueExample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 13/08/26.
//

import Foundation
import SwiftUI
import Combine

struct OperationQueueExampleView: View {
    @StateObject var viewModel: OperationQueueExampleViewModel = OperationQueueExampleViewModel()
    var body: some View {
        Text("OperationQueue")
        Text(viewModel.displayText)
            .task {
                let operationQueue = OperationQueue()
                if let url = URL(string: "https://dummyjson.com/products/1") {
                    let fetchOperation = FetchDataOperation(url: url)
                    let parseOperation = ParseDataOperation(fetchOperation: fetchOperation)
                    let displayOperation = DisplayOperation(parseOperation: parseOperation, viewModel: viewModel)
                    parseOperation.addDependency(fetchOperation)
                    displayOperation.addDependency(parseOperation)
                    operationQueue.addOperation(fetchOperation)
                    operationQueue.addOperation(parseOperation)
                    OperationQueue.main.addOperation(displayOperation)
                }
                
            }
    }
}
class FetchDataOperation: Operation {
    
    var url: URL
    
    var fetchedData: Data?
    
    var dispatchSemaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    deinit {
        print("FetchDataOperation deinited")
    }
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        print("1.Fetch data operation started")
        if isCancelled {
            print("Fetch cancelled before starting")
            return
        }
        fetchData()
        dispatchSemaphore.wait()
        print("3.Fetch data operation returned")
    }
    
    override func cancel() {
        super.cancel()
        dispatchSemaphore.signal()
    }
    
    func fetchData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let self = self else { return }
            if self.isCancelled {
                print("Fetch operation cancelled during async running")
                self.dispatchSemaphore.signal()
                return
            }
            self.fetchedData = Data()
            print("2.i am coming after completion")
            self.dispatchSemaphore.signal()
        })
    }
}

class ParseDataOperation: Operation {
    var parsedResult: String?
    
    var fetchOperation: FetchDataOperation
    
    var dispatchSemaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    
    init(fetchOperation: FetchDataOperation) {
        self.fetchOperation = fetchOperation
    }
    
    override func main() {
        if isCancelled { return }
        print("4.ParseDataOperation started")
        guard let data = fetchOperation.fetchedData else {
            print("ParseDataOperation returned before")
            return
        }
        parseData()
        dispatchSemaphore.wait()
        print("5.ParseDataOperation returned")
        print("Parsing finished: \(parsedResult)")
    }
    
    func parseData() {
        Thread.sleep(forTimeInterval: 2)
        parsedResult = "ParsedJohn"
        dispatchSemaphore.signal()
    }
}

class DisplayOperation: Operation {
    
    var parseOperation: ParseDataOperation?
    var viewModel: OperationQueueExampleViewModel
    var dispatchSemaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    init(parseOperation: ParseDataOperation? = nil, viewModel: OperationQueueExampleViewModel) {
        self.parseOperation = parseOperation
        self.viewModel = viewModel
    }
    
    
    
    override func main() {
        print("Display operation started")
        if self.isCancelled {
            print("Display operation cancelled before starting")
            return
        }
        guard let data = parseOperation?.parsedResult else {
            return
        }
        processAndDisplay(data: data)
    }
    
    func processAndDisplay(data: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.viewModel.displayText = data
        })
    }
}

class OperationQueueExampleViewModel: ObservableObject {
    @Published var displayText: String = ""
}
