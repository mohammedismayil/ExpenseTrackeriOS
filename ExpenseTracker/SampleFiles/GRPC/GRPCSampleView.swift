//
//  GRPCSampleView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 08/07/26.
//

//import SwiftUI
//import GRPCCore
//import GRPCNIOTransportHTTP2
//import SwiftProtobuf
//struct GRPCSampleView: View {
//    @State var users: [User_UserResponse] = []
//    @State var categoryResponse: User_GetCategoriesResponse = User_GetCategoriesResponse()
//    var body: some View {
//        Text("GRPC Sample")
//        List {
//            ForEach(categoryResponse.categories.enumerated(), id: \.offset) { _, user in
//                Text(user.name)
//            }
//        }.task {
//            await fetchCategories()
//        }
//    }
//    
//    func fetchUsers() async {
//        do {
//            try await withGRPCClient(transport: HTTP2ClientTransport.Posix(
//                target: .dns(host: "127.0.0.1", port: 50051),
//                transportSecurity: .plaintext
//            )) { client in
//                let service = User_UserService.Client(wrapping: client)
//                let response = try await service.getAllUsers(User_EmptyRequest())
//                users = response.users
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func fetchCategories() async {
//        do {
//            try await withGRPCClient(transport: HTTP2ClientTransport.Posix(
//                target: .dns(host: "127.0.0.1", port: 50051),
//                transportSecurity: .plaintext
//            )) { client in
//                let service = User_UserService.Client(wrapping: client)
//                let response = try await service.getCategories(request: .init(message: User_GetCategoriesRequest()))
//                self.categoryResponse = response
//            }
//        } catch {
//            print(error)
//        }
//    }
//}
//
//#Preview {
//    GRPCSampleView()
//}
