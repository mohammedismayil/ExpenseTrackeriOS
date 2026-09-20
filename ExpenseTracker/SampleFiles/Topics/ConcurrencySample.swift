//
//  ConcurrencySample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 20/09/26.
//

import SwiftUI

struct ConcurrencySampleView: View {
    var body: some View {
        Text("")
        .task {
            checkMainThread()
        }
    }
    
    func checkMainThread() {
        print("1")
//        DispatchQueue.main.sync {
//            print("2")
//        }
//        DispatchQueue.main.async {
//            print("2")
//            DispatchQueue.global().sync {
//                print("3")
//            }
//        }
//        DispatchQueue.global().sync {
//            print("4")
//        }
    }
}
