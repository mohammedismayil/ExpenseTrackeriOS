//
//  GCDSample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 07/08/26.
//

import Foundation
class GCDSample {
    
    func checkSerialQueue() {
        let serial = DispatchQueue(label: "Serial")
        for i in 0..<5 {
            serial.async {
                print("\(i)started")
                Thread.sleep(forTimeInterval: TimeInterval(Int.random(in: 0...3)))
                print("\(i)ended")
            }
        }
    }
    
    func checkConcurrentQueue() {
        let serial = DispatchQueue(label: "concurrent", attributes: .concurrent)
        for i in 0..<5 {
            serial.async {
                print("\(i)started")
                Thread.sleep(forTimeInterval: TimeInterval(Int.random(in: 0...3)))
                print("\(i)ended")
            }
        }
    }
}
