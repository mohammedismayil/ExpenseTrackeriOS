//
//  GroupExample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 08/11/26.
//

import SwiftUI

struct GroupExample: View {
    var body: some View {
        Text("Header")
        Group {
            Text("Title")//.font(.caption)
            Text("description")
        }.font(.largeTitle)
    }
}

#Preview {
    GroupExample()
}
