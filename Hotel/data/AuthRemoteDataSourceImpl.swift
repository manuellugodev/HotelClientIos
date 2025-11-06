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

    func register(username: String, firstName: String, lastName: String, email: String, phone: String, password: String) async throws -> RegisterResponse {
        let registerRequest = RegisterRequest(
            username: username,
            firstName: firstName,
            password: password,
            lastName: lastName,
            email: email,
            phone: phone
        )
        let encoder = JSONEncoder()
        let body = try encoder.encode(registerRequest)

        return try await networkManager.fetch(
            endpoint: "/user/register",
            method: "POST",
            body: body,
            requiresAuth: false  // Register doesn't require auth
        )
    }
}
