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
        Text("Sample Testing Detail View")
            .onAppear {
                zombieExample()
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
}

#Preview {
//    SampleTestingDetailView()
}
