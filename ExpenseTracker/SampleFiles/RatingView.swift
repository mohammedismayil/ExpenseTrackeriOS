//
//  RatingView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/07/26.
//

import SwiftUI

struct RatingContainerView: View {
    @State var rating: Int = 0
    var body: some View {
        Gauge(value: Float(rating), in: 0...10) {
            Text("Rating")
        }.contentTransition(.numericText(value: Double(rating)))
        RatingView(rating: $rating)
    }
}

struct RatingView: View {
    @Binding var rating: Int
    var body: some View {
        Button("Decrease", systemImage: "minus.circle") {
            withAnimation {
                rating -= 1
            }
            
        }
        Text(rating.description).bold().font(.system(size: 50)).contentTransition(.numericText(value: Double(rating))).swipeActions {
            Button ("Rating swiped") {
                print("Swiped")
            }
        }
        Button("Increase", systemImage: "plus.circle") {
            withAnimation {
                rating += 1
            }
        }
    }
}

//#Preview {
//    RatingView(rating: $0)
//}
