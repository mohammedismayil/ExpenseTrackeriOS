//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/06/26.
//

import SwiftUI
import CoreData

@main
struct ExpenseTrackerApp: App {

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab ("", systemImage: "pencil.circle", content: {
                    HomeView()
                })
                Tab ("", systemImage: "pencil.circle", content: {
                    ContentView()
                })
                Tab ("", systemImage: "pencil.circle", content: {
                    ContentView()
                })
                Tab ("", systemImage: "pencil.circle", content: {
                    ContentView()
                })
            }
        }
    }
}
