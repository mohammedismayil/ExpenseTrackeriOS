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
    @StateObject var viewModel: SampleViewModel = SampleViewModel(repository: SampleUserRepository(service: MockAPIService()))
    var body: some View {
        if viewModel.error != nil {
            Text("\(viewModel.error?.localizedDescription)")
        } else {
            List(viewModel.userData) { user in
                Text(user.title)
            }.onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
                
            }
        }
    }
}

struct SampleUser: Decodable, Identifiable {
    var id: Int
    var priority: Int
    var title: String
    init(id: Int, priority: Int, title: String) {
        self.id = id
        self.priority = priority
        self.title = title
    }
}

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [SampleUser]
}

protocol UserRepositoryProtocol {
    func fetchUsers() async throws -> [SampleUser]
}

final class SampleUserRepository: UserRepositoryProtocol {
    func fetchUsers() async throws -> [SampleUser] {
        try await service.fetchUsers()
    }
    
    var service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
}
final class FetchUserAPIService: UserServiceProtocol {
    func fetchUsers() async throws -> [SampleUser] {
        guard let url = URL(string: "sample") else {
            return []
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response  = response as? HTTPURLResponse else {
                throw FetchUserError.noResponse
            }
            guard let decoder = try? JSONDecoder().decode([SampleUser].self, from: data) else {
                throw FetchUserError.decodeError
            }
            return decoder
        } catch {
            throw FetchUserError.noInternet
        }
        
    }
    
    
}
class SampleViewModel: ObservableObject {
    @Published var userData: [SampleUser] = []
    
    @Published var error: Error?
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUsers() async {
        do {
            let users = try await repository.fetchUsers()
            userData = users.sorted {
                $0.priority > $1.priority
            }
        } catch {
            self.error = error
        }
    }
}

final class MockAPIService: UserServiceProtocol {
    func fetchUsers() async throws -> [SampleUser] {
        do {
            try await Task.sleep(for: .seconds(3))
            return [SampleUser(id: 1, priority: 1, title: "john"),SampleUser(id: 2, priority: 2, title: "peter")]
        } catch {
            throw FetchUserError.noResponse
        }
    }
}

enum FetchUserError: Error {
    case noInternet
    case decodeError
    case noResponse
}
