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
    @StateObject var viewModel: SampleViewModel = SampleViewModel(repository: SampleUserRepository(service: FetchUserAPIService()))
    var body: some View {
        Group {
            if viewModel.fetchState == .fetchError {
                Text("\(viewModel.error?.localizedDescription)")
            }else if viewModel.fetchState == .initialLoading {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.userData) { user in
                        Text(user.name).onAppear {
                            Task {
                                await viewModel.fetchNextUsers()
                            }
                        }
                    }
                    if viewModel.fetchState == .paginationLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    
                }
                
            }
        }
        .task {
            await viewModel.fetchUsers()
        }
        
    }
}

struct SampleUserResponse: Decodable, Identifiable {
    var id: String
    var userList: [SampleUser] = []
    var isNextPageAvailable: Bool = false
    
    init(userList: [SampleUser], isNextPageAvailable: Bool) {
        self.userList = userList
        self.isNextPageAvailable = isNextPageAvailable
        self.id = UUID().uuidString
    }
}

struct SampleUser: Decodable, Identifiable {
    var id: Int
    var name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

protocol UserServiceProtocol {
    func fetchUsers(pageNumber: Int) async throws -> SampleUserResponse
}

protocol UserRepositoryProtocol {
    func fetchUsers(pageNumber: Int) async throws -> SampleUserResponse
}

final class SampleUserRepository: UserRepositoryProtocol {
    func fetchUsers(pageNumber: Int) async throws -> SampleUserResponse {
        try await service.fetchUsers(pageNumber: pageNumber)
    }
    
    var service: UserServiceProtocol
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
}
final class FetchUserAPIService: UserServiceProtocol {
    func fetchUsers(pageNumber: Int) async throws -> SampleUserResponse {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users?_page=\(pageNumber)&_limit=2") else {
            return SampleUserResponse(userList: [], isNextPageAvailable: false)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let _  = response as? HTTPURLResponse else {
                throw FetchUserError.noResponse
            }
            guard let list = try? JSONDecoder().decode([SampleUser].self, from: data) else {
                throw FetchUserError.decodeError
            }
            return SampleUserResponse(userList: list, isNextPageAvailable: pageNumber <= 4)
        } catch {
            throw FetchUserError.noInternet
        }
        
    }
    
}

@MainActor
class SampleViewModel: ObservableObject {
    @Published var userData: [SampleUser] = []
    
    @Published var pageNumber: Int = 1
    
    @Published var fetchState: FetchState = .idle
    
    @Published var isNextPageNeeded: Bool = false
    
    @Published var error: Error?
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUsers() async {
        do {
            fetchState = pageNumber == 1 ? .initialLoading : .paginationLoading
            let users = try await repository.fetchUsers(pageNumber: pageNumber)
            userData.append(contentsOf: users.userList)
            isNextPageNeeded = users.isNextPageAvailable
            fetchState = .completed
        } catch {
            self.error = error
            fetchState = .fetchError
        }
    }
    
    func fetchNextUsers() async {
        do {
            guard fetchState != .paginationLoading, isNextPageNeeded else {
                return
            }
            fetchState = .paginationLoading
            try await Task.sleep(for: .seconds(2))
            let users = try await repository.fetchUsers(pageNumber: pageNumber + 1)
            userData.append(contentsOf: users.userList)
            pageNumber += 1
            isNextPageNeeded = users.isNextPageAvailable
            fetchState = .completed
        } catch {
            self.error = error
            fetchState = .fetchError
        }
    }
}

final class MockAPIService: UserServiceProtocol {
    func fetchUsers(pageNumber: Int) async throws -> SampleUserResponse {
        do {
            try await Task.sleep(for: .seconds(3))
            return SampleUserResponse(userList: [SampleUser(id: 1, name: "john"),SampleUser(id: 2, name: "peter")], isNextPageAvailable: false)
        } catch {
            throw FetchUserError.noResponse
        }
    }
}

enum FetchState {
    case idle
    case initialLoading
    case paginationLoading
    case completed
    case fetchError
}

enum FetchUserError: Error {
    case noInternet
    case decodeError
    case noResponse
}
