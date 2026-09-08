//
//  SearchDebounceView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 06/09/26.
//

import SwiftUI
import Combine

struct SearchDebounceView: View {
    @State var searchText: String = ""
    @State var cancellable: AnyCancellable?
    @State var subject = PassthroughSubject<String, Never>()
    var body: some View {
        VStack {
            Text("SearchDebounceView")
            TextField("Search", text: $searchText).onChange(of: searchText) { oldValue, newValue in
                subject.send(newValue)
            }
        }
        .onAppear {
            cancellable = subject.debounce(for: .milliseconds(300), scheduler: RunLoop.main).sink(receiveValue: { value in
                Task {
                    await searchAPI(value: value)
                }
            })
        }
    }
    
    func searchAPI(value: String) async {
        print("Search api called for \(value)")
    }
}

#Preview {
    SearchDebounceView()
}
