//
//  SampleUserListView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 05/07/26.
//

import SwiftUI
import SwiftData

struct SampleUserListView: View {
    @Query var users: [UserEntity]
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationStack {
            VStack {
                Text("User List view")
                List() {
                    ForEach(users) { user in
                        Text(user.name)
                    }.onDelete { (index) in
                        for index in index {
                            modelContext.delete(users[index])
                        }
                    }
                }
            }
            .toolbar {
                Button("Add") {
                    let user = UserEntity(name: "Ismayil")
                    modelContext.insert(user)
                }
            }
        }
        
        
    }
}

@Model
final class UserEntity: Identifiable {
    var id: String
    var name: String
    init(name: String) {
        self.name = name
        self.id = UUID().uuidString
    }
}


//#Preview {
//    SampleUserListView()
//}
