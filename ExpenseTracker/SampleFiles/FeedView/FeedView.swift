//
//  FeedView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 23/07/26.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.feeds) { feed in
                    Text(feed.user.name)
                }
            }
        }.navigationTitle("Timeline")
            .task {
                await viewModel.loadFeed()
            }
    }
}

#Preview {
    FeedView()
}
