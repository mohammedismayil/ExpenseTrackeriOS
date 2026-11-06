//
//  NavigationTestingHomeView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 13/10/26.
//

import SwiftUI
import WidgetKit

struct NavigationTestingHomeView: View {
    @State var selectedUser: String?
    var array: [String] = ["john","peter", "smith"]
    var body: some View {
        NavigationStack {
            Button("Expense") {
                incrementExpense()
            }
            List(array, id: \.self) { item in
                NavigationLink(destination: NavigationTestingDetailView(user: item)) {
                    Button(item){
                        
                    }
                }
            }
            Button("Open Next") {
                selectedUser = array.randomElement()
            }.navigationTitle("Navigation Testing")
//                .navigationDestination(isPresented: $isOpenNext) {
//                    NavigationTestingDetailView()
//                }
                .navigationDestination(item: $selectedUser) { value in
                    NavigationTestingDetailView(user: value)
                }
        }.onAppear {
            Task {
                let obj = AsyncFundamentals()
                let myTask = Task {
                    do {
                        let main = try await obj.getMainData()
                        let stat = try await obj.getStatData()
                        let user = try await obj.getUserData()
                        print("all done: \((main,stat,user))")
                    } catch {
                        print("\(error) catched on mytask")
                    }
                }
                try? await Task.sleep(for: .seconds(2))
                myTask.cancel()
            }
            
        }
       
    }
    
    
    func incrementExpense() {
        let defaults = UserDefaults(suiteName: "group.ismayil.expensetracker")
        if let existingValue = defaults?.double(forKey: "totalexpense") {
            defaults?.set(existingValue+100, forKey: "totalexpense")
        } else {
            defaults?.set(1000.0, forKey: "totalexpense")
        }
        print("APP SAVED:", defaults?.object(forKey: "totalexpense") ?? "nil")
        print("APP READ:", defaults?.double(forKey: "totalexpense") ?? -1)
        WidgetCenter.shared.reloadAllTimelines()
        
    }
}

#Preview {
    NavigationTestingHomeView()
}
