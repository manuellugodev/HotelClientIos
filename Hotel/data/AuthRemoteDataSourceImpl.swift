//
//  AuthRemoteDataSourceImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

class AuthRemoteDataSourceImpl: AuthRemoteDataSource {
    private let networkManager: BaseNetworkManager

    init(networkManager: BaseNetworkManager) {
        self.networkManager = networkManager
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        let loginRequest = LoginRequest(username: username, password: password)
        let encoder = JSONEncoder()
        let body = try encoder.encode(loginRequest)

        return try await networkManager.fetch(
            endpoint: "/login",
            method: "POST",
            body: body,
            requiresAuth: false  // Login doesn't require auth
        )
    }
}
