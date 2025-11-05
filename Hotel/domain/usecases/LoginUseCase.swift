//
//  LoginUseCase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol LoginUseCase {
    func execute(username: String, password: String) async -> Result<User, Failure>
}

class LoginInteractor: LoginUseCase {
    private let repository: AuthRepository
    private let tokenManager: TokenManager

    init(repository: AuthRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
    }

    func execute(username: String, password: String) async -> Result<User, Failure> {
        // Validate inputs
        guard !username.isEmpty else {
            return .failure(.validationError("Username cannot be empty"))
        }

        guard !password.isEmpty else {
            return .failure(.validationError("Password cannot be empty"))
        }

        // Call repository
        let result = await repository.login(username: username, password: password)

        // If successful, save token
        if case .success(let user) = result {
            tokenManager.saveToken(user.token)
            tokenManager.saveUsername(username)
        }

        return result
    }
}
