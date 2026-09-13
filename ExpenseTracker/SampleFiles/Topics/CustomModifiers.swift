//
//  CustomModifiers.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 13/09/26.
//

import SwiftUI


struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .background(Color.green)
            .foregroundStyle(.white)
    }
}

extension View {
    func primaryButtonModifier() -> some View {
        modifier(PrimaryButtonModifier())
    }
}
