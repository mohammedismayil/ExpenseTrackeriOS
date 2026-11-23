//
//  SearchDebounceView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 06/09/26.
//

import SwiftUI
import Combine
import Foundation

struct SearchDebounceView: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    
    @State var searchText: String = ""
    
    @State var searchTask: Task<Void, Never>?
    var body: some View {
        VStack {
            Text("SearchDebounceView")
            TextField("Search", text: $searchText)
                .onChange(of: searchText) {
                    Task {
                        await searchAPI(value: searchText)
                    }
                }
        }
    }
    
    
    func searchAPI(value: String) async {
        
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .seconds(2))
            if Task.isCancelled {
                return
            }
            print("Search api called for \(value)")
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
