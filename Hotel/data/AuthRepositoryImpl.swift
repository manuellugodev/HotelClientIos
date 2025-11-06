//
//  AuthRepositoryImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let remoteDataSource: AuthRemoteDataSource

    init(remoteDataSource: AuthRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func login(username: String, password: String) async -> Result<User, Failure> {
        do {
            let response = try await remoteDataSource.login(username: username, password: password)

            // Map LoginResponse to User domain model
            let user = User(
                username: username,  // API doesn't return username, use the input
                guestId: response.guestId,
                token: response.token
            )

            return .success(user)

        } catch let error as APIError {
            // Map APIError to Failure
            return .failure(mapAPIErrorToFailure(error))

        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func register(username: String, firstName: String, lastName: String, email: String, phone: String, password: String) async -> Result<Void, Failure> {
        do {
            _ = try await remoteDataSource.register(
                username: username,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                password: password
            )

            // Registration successful, return success
            return .success(())

        } catch let error as APIError {
            // Map APIError to Failure
            return .failure(mapAPIErrorToFailure(error))

        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    private func mapAPIErrorToFailure(_ error: APIError) -> Failure {
        switch error {
        case .serverError(let message, let code):
            if code == 401 || code == 403 {
                return .validationError("Invalid username or password")
            }
            return .serverError(message)
        case .invalidResponse:
            return .serverError("Invalid response from server")
        case .decodingError(let error):
            return .invalidData("Failed to decode response: \(error.localizedDescription)")
        case .networkError(let error):
            return .connectionError("Network error: \(error.localizedDescription)")
        }
    }
}
