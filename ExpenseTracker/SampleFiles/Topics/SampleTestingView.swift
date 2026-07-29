//
//  SampleTestingView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 29/07/26.
//

import SwiftUI

struct SampleTestingView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                SampleTestingDetailView(name: "")
            } label: {
                Text("Sample Testing")
            }
        }
        
    }
}

#Preview {
    SampleTestingView()
}
