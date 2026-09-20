//
//  DemoViewModelView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 18/09/26.
//

import SwiftUI
import Combine

struct DemoViewModelView: View {
    @StateObject var viewModel: DemoViewModel = DemoViewModel()
    var body: some View {
        Text("Demo View Model")
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.errorState == nil {
            List(viewModel.users) { item in
                Text(item.name)
            }
        } else {
            Text("Error state: \(viewModel.errorState)")
        }
        
        Button("Next action") {
            print("Next action")
        }.frame(minHeight: 30).padding(10)
        .themeButtonModifier()
        .task {
            await viewModel.fetchUsers()
        }
            
    }
}
class DemoViewRepository {
    let service: DemoViewService
    
    init(service: DemoViewService) {
        self.service = service
    }
    func fetchUsers() async throws -> [DemoUserModel] {
        return try await service.fetchUsers()
    }
}
class DemoViewService {
    func fetchUsers() async throws -> [DemoUserModel] {
        try Task.checkCancellation()
        let urlSession = URLSession.shared
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw DemoViewErrors.urlError
        }
        do {
            let (data, response) = try await urlSession.data(from: url)
            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
                throw DemoViewErrors.fetchError
            }
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([DemoUserModel].self, from: data)
                return users
            } catch {
                throw DemoViewErrors.decodeError
            }
        }
        catch {
            throw DemoViewErrors.fetchError
        }
        
    }
}

@MainActor
class DemoViewModel: ObservableObject {
    @Published var users: [DemoUserModel] = []
    @Published var isLoading: Bool = false
    @Published var errorState: DemoViewErrors?
    
    var repository: DemoViewRepository = DemoViewRepository(service: DemoViewService())
    
    func fetchUsers() async {
        do {
            isLoading = true
            try await Task.sleep(for: .seconds(4))
            users = try await repository.fetchUsers()
            isLoading = false
        } catch {
            isLoading = false
            if let parsedError = error as? DemoViewErrors {
                print("error state : \(parsedError)")
                errorState = parsedError
            }
        }
    }
    
    
}

enum DemoViewErrors: Error {
    case fetchError
    case decodeError
    case urlError
}

struct DemoUserModel: Codable, Identifiable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct ThemeButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color.yellow).cornerRadius(10).foregroundColor(.black)
    }
}

extension View {
    func themeButtonModifier() -> some View {
        modifier(ThemeButtonModifier())
    }
}

#Preview {
    DemoViewModelView()
}
