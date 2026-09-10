//
//  StateObjectSampleView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 10/09/26.
//

import SwiftUI
import Combine

struct StateObjectSampleView: View {
    @State var count: Int = 0
    var body: some View {
        Text("StateObject vs ObservableObject")
        HStack {
            Button("+"){
                count += 1
            }
            Text("\(count)")
            Button("-") {
                count -= 1
            }
            ResettingCounterView()
        }
        
    }
}

struct ResettingCounterView: View {
    @ObservedObject var viewModel: ResettingCounterViewModel = ResettingCounterViewModel()
    var body: some View {
        Text("ResettingCounterView")
        Text("\(viewModel.count)")
        HStack {
            Button("+"){
                viewModel.count += 1
            }
            Button("-") {
                viewModel.count -= 1
            }
        }
    }
}

class ResettingCounterViewModel : ObservableObject {
    @Published var count: Int = 0
}

#Preview {
    StateObjectSampleView()
}
