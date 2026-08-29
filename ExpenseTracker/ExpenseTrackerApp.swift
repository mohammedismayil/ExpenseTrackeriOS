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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var cartViewModel: CartViewViewModel = CartViewViewModel()
    @UIApplicationDelegateAdaptor(Appdelegate.self)
    var appdelegate
    var body: some Scene {
        
//        WindowGroup {
//                    ContentView()
//                }
        WindowGroup {
            if #available(iOS 18.0, *) {
                TabView {
                    Tab ("", systemImage: "house", content: {
                        EnvironmentObjectHomeView()
//                        HomeView()
//                        ResumableDownloadView()
//                        XCUITestDemoView()
//                        OperationQueueExampleView()
                    })
                    Tab ("", systemImage: "magnifyingglass", content: {
                        EnvironmentalObjectProductDetailView()
//                        SampleUserListView()
//                        ProductsListView()
//                        FeedView()
//                        SampleTestingView()
                    })
                    Tab ("", systemImage: "plus", content: {
//                        PhotosListView(searchText: "")
                        CartScreenView()
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
                    Tab ("", systemImage: "person.fill", content: {
                        //                    GRPCSampleView()
                    })
                }.environmentObject(cartViewModel)
            } else {
                // Fallback on earlier versions
            }
        }.modelContainer(for: UserEntity.self)
            .onChange(of: scenePhase) { oldValue, newValue in
                switch newValue {
                    
                case .background:
                    print("App gone to background")
                case .inactive:
                    print("App gone to Inactive")
                case .active:
                    print("App gone to active")
                @unknown default:
                    print("Default state on appstate change")
                }
            }
    }
}
