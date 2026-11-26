//
//  BarrierExampleView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 26/11/26.
//

import SwiftUI

struct BarrierExampleView: View {
    var body: some View {
        Text("Barrier")
            .onAppear {
                testBarrier()
            }
    }
    
    
    func testBarrier() {
        
        var users: [Int] = []
        
        let queue: DispatchQueue = DispatchQueue(label: "barrier", attributes: .concurrent)
        
        for i in 0..<100 {
            // this will crash since multiple objects try to append at same time
//            queue.async {
//                users.append(i)
//            }
            
            queue.async(flags: .barrier) {
                users.append(i)
            }
        }
    }
}

#Preview {
    BarrierExampleView()
}
