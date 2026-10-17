//
//  NavigationTestingHomeView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 13/10/26.
//

import SwiftUI

struct NavigationTestingHomeView: View {
    @State var selectedUser: String?
    var array: [String] = ["john","peter", "smith"]
    var body: some View {
        NavigationStack {
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
                try? await Task.sleep(for: .seconds(3))
                myTask.cancel()
            }
            
        }
       
    }
}

#Preview {
    NavigationTestingHomeView()
}
