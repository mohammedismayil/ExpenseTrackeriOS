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
                let clock = ContinuousClock()
                let time = try await clock.measure {
                    async let main = try obj.getMainData()
                    async let stat = try obj.getStatData()
                    async let user = try obj.getUserData()
                    print(await main,stat,user)
                }
               print("elapsed time \(time)")
            }
            
        }
       
    }
}

#Preview {
    NavigationTestingHomeView()
}
