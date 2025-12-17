//
//  LoginViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    nonisolated(unsafe) private let loginUseCase: LoginUseCase
    nonisolated(unsafe) var onLoginSuccess: (() -> Void)?

    nonisolated init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() {
        // Clear previous error
        errorMessage = nil
        isLoading = true

        Task {
            let result = await loginUseCase.execute(username: username, password: password)

            isLoading = false

            switch result {
            case .success(let user):
                print("Login successful for user: \(user.username), guestId: \(user.guestId)")
                onLoginSuccess?()

            case .failure(let error):
                errorMessage = error.message
            }
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
