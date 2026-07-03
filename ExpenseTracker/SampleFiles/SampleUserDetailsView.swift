//
//  SampleUserDetailsView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 03/07/26.
//

import SwiftUI

struct SampleUserDetailsView: View {
    @State var userDetails: [UserDetails]
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    var body: some View {
        Text("User Details").onAppear {
            Task {
                do {
                    self.isLoading = true
                    self.userDetails = try await fetchDetailsFromAPI()
                    self.isLoading = false
                    self.isError = userDetails.count > 0 ? false : true
                } catch {
                    self.isLoading = false
                    self.isError = true
                }
                
            }
        }
        if isLoading {
            ProgressView()
        } else if isError {
            Text("Error occurred")
        } else {
            List(userDetails) { user in
                Text(user.name)
            }
        }
        
    }
    
    func fetchDetailsFromAPI() async throws -> [UserDetails] {
        try await Task.sleep(for: .seconds(2))
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return []
        }
        let urlSession = URLSession.shared
        guard let (data, resp) = try? await urlSession.data(from: url) else {
            return []
        }
        if let response = resp as? HTTPURLResponse, response.statusCode != 200 {
            throw APIError.fetchFailed
        }
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode([UserDetails].self, from: data)
    }
}

enum APIError: Error {
    case fetchFailed
}
struct UserDetails: Codable, Identifiable {
    let id: Int
    let name: String
}

//#Preview {
//    SampleUserDetailsView()
//}
