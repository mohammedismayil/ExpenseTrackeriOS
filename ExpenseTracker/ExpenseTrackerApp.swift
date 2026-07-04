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
                Tab ("", systemImage: "house", content: {
                    HomeView()
                })
                Tab ("", systemImage: "magnifyingglass", content: {
                    ContentView()
                })
                Tab ("", systemImage: "plus", content: {
                    RatingContainerView()
                })
                Tab ("", systemImage: "chart.pie.fill", content: {
                    SampleUserDetailsView(userDetails: [])
                })
                Tab ("", systemImage: "person.fill", content: {
                    if  LoginViewModel().isLoggedIn {
                        LoggedInUserView()
                    } else {
                        LoginView()
                    }

                })
            }
        }
    }
}
