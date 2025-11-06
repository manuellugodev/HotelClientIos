//
//  RegisterViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/6/25.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showSuccessAlert: Bool = false

    // Field-specific error messages
    @Published var usernameError: String? = nil
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var emailError: String? = nil
    @Published var phoneError: String? = nil
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil

    private let registerUseCase: RegisterUserUseCase
    var onRegisterSuccess: (() -> Void)?

    init(registerUseCase: RegisterUserUseCase) {
        self.registerUseCase = registerUseCase
    }

    func register() {
        // Clear all previous errors
        clearErrors()

        // Validate confirm password matches
        if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
            return
        }

        isLoading = true

        Task {
            let result = await registerUseCase.execute(
                username: username,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                password: password
            )

            isLoading = false

            switch result {
            case .success:
                print("Registration successful for user: \(username)")
                showSuccessAlert = true
                onRegisterSuccess?()

            case .failure(let error):
                handleError(error)
            }
        }
    }

    private func handleError(_ error: Failure) {
        // Clear field errors first
        clearFieldErrors()

        // Check if it's a validation error and try to map it to specific field
        if case .validationError(let message) = error {
            // Map the error message to the specific field
            if message.contains("Username") {
                usernameError = message
            } else if message.contains("First name") {
                firstNameError = message
            } else if message.contains("Last name") {
                lastNameError = message
            } else if message.contains("Email") || message.contains("email") {
                emailError = message
            } else if message.contains("Phone") {
                phoneError = message
            } else if message.contains("Password") {
                passwordError = message
            } else {
                errorMessage = message
            }
        } else {
            // For server errors or other errors, show general error message
            errorMessage = error.message
        }
    }

    func clearErrors() {
        errorMessage = nil
        clearFieldErrors()
    }

    private func clearFieldErrors() {
        usernameError = nil
        firstNameError = nil
        lastNameError = nil
        emailError = nil
        phoneError = nil
        passwordError = nil
        confirmPasswordError = nil
    }

    var isFormValid: Bool {
        return !username.isEmpty &&
               !firstName.isEmpty &&
               !lastName.isEmpty &&
               !email.isEmpty &&
               !phone.isEmpty &&
               !password.isEmpty &&
               !confirmPassword.isEmpty &&
               password == confirmPassword
    }
}
