//
//  SampleViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 30/08/26.
//

import Foundation
import Combine
import SwiftUI

struct SampleUsersListView: View {
    @StateObject var viewModel: SampleViewModel = SampleViewModel()
    var body: some View {
        List(viewModel.userData) { user in
            Text(user.title)
        }.onAppear {
            Task {
                await viewModel.fetchUsers()
            }
            
        }
    }
}

class SampleUser: Decodable, Identifiable {
    var id: Int
    var priority: Int
    var title: String
    init(id: Int, priority: Int, title: String) {
        self.id = id
        self.priority = priority
        self.title = title
    }
}

protocol FetchUserProtocol {
    func fetchUsers() async -> [SampleUser]?
}

class SampleUserRepository {
    
    var service: FetchUserProtocol
    
    init(service: FetchUserProtocol) {
        self.service = service
    }
    func fetchUsers() async -> [SampleUser]? {
        await service.fetchUsers()
    }
    
    
}
class FetchUserAPIService: FetchUserProtocol {
    func fetchUsers() async -> [SampleUser]? {
        guard let url = URL(string: "sample") else {
            return []
        }
        do {
            let (response, data) = try await URLSession.shared.data(from: url)
            guard let decoder = try? JSONDecoder().decode([SampleUser].self, from: response) else { return [] }
            return decoder
        } catch {
            return []
        }
        
    }
    
    
}
class SampleViewModel: ObservableObject {
    @Published var userData: [SampleUser] = []
    
    func fetchUsers() async {
        let service: FetchUserProtocol = MockAPIService()
        async let users = service.fetchUsers()
        userData = await users?.sorted {
            $0.priority > $1.priority
        } ?? []
        
    }
}

class MockAPIService: FetchUserProtocol {
    func fetchUsers() async -> [SampleUser]? {
        do {
            try await Task.sleep(for: .seconds(3))
            return [SampleUser(id: 1, priority: 1, title: "john"),SampleUser(id: 2, priority: 2, title: "peter")]
        } catch {
            return []
        }
    }
}
