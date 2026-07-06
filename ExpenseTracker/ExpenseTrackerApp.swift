//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/06/26.
//

import SwiftUI
import CoreData
import SwiftData

@main
struct ExpenseTrackerApp: App {
    @State private var loginViewModel = LoginViewModel()
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab ("", systemImage: "house", content: {
                    HomeView()
                })
                Tab ("", systemImage: "magnifyingglass", content: {
                    SampleUserListView()
                })
                Tab ("", systemImage: "plus", content: {
                    PhotosListView()
                })
                Tab ("", systemImage: "chart.pie.fill", content: {
                    SampleUserDetailsView(userDetails: [])
                })
                Tab ("", systemImage: "person.fill", content: {
                    if  loginViewModel.isLoggedIn {
                        LoggedInUserView()
                    } else {
                        LoginView()
                    }

                })
            }
        }.modelContainer(for: UserEntity.self)
    }
}
