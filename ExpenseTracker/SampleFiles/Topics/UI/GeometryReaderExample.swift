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
                Rectangle()
                    .fill(.green)
                .frame(height: proxy.size.height*0.8)
                
                
                Rectangle()
                    .background(.yellow)
                .frame(height: proxy.size.height*0.2)
            }
            
        }
        
        .background(.gray)
    }
}

#Preview {
    GeometryReaderExample()
}
