//
//  LoginViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 04/07/26.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    var isLoggedIn: Bool {
        if let isLogged = UserDefaults.standard.value(forKey: "loggedin") as? Bool {
            return isLogged
        } else {
            return false
        }
    }
    
    @Published var isError: Bool = false
    
    @Published var isLoading: Bool = false
    
    
    var authService: AuthServiceProtocol = MockAuthService()
    
    func login() async {
        do {
            isLoading = true
            defer {
                isLoading = false
            }
            let service = try await authService.login(username: email, password: password)
            LoginViewModel.saveUserLoggedIn(username: service.userName, token: service.token)
            isError = false
        } catch {
            if let _ = error as? LoginError {
                isError = true
            }
        }
    }
    
    static func saveUserLoggedIn(username: String, token: String) {
        UserDefaults.standard.setValue(true, forKey: "loggedin")
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedin")
    }
    
    
}

struct User: Codable, Identifiable {
    let id: String
    let token: String
    let userName: String
}

protocol AuthServiceProtocol {

    func login(
        username: String,
        password: String
    ) async throws -> User
}

class MockAuthService : AuthServiceProtocol{
    func login(username: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        if username == "Admin@gmail.com" && password == "123456" {
            return User(id: "user", token: "login", userName: "Admin")
        } else {
            throw LoginError.credentialsError
        }
    }
}

enum LoginError : Error {
    case credentialsError
}
