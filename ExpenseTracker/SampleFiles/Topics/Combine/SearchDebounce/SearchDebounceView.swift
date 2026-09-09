//
//  SearchDebounceView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 06/09/26.
//

import SwiftUI
import Combine

struct SearchDebounceView: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    var body: some View {
        VStack {
            Text("SearchDebounceView")
            TextField("Search", text: $viewModel.searchText)
        }
    }
    
    
}

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main).sink(receiveValue: { [weak self] value  in
            Task {
                await self?.searchAPI(value: value)
            }
        })
    }
    
    
    func searchAPI(value: String) async {
        print("Search api called for \(value)")
    }
    
    
}

#Preview {
    SearchDebounceView()
}
