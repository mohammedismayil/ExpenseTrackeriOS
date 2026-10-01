//
//  GeometryReaderExample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 26/09/26.
//

import SwiftUI

struct GeometryReaderExample: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack {
                    Text("Yellow")
                }
                .frame(height: proxy.size.height*1)
                .background(.yellow)
            }
            .onAppear() {
                print(proxy.frame(in: .global).size)
            }
                .background(.blue)
            
        }
        .background(.gray)
    }
}

#Preview {
    GeometryReaderExample()
}
