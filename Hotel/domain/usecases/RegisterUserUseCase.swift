//
//  RegisterUserUseCase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/6/25.
//

import Foundation

enum RegisterValidationError: Error {
    case emptyUsername
    case emptyFirstName
    case emptyLastName
    case emptyEmail
    case invalidEmail
    case emptyPhone
    case invalidPhone
    case emptyPassword
    case weakPassword

    var message: String {
        switch self {
        case .emptyUsername:
            return "Username cannot be empty"
        case .emptyFirstName:
            return "First name cannot be empty"
        case .emptyLastName:
            return "Last name cannot be empty"
        case .emptyEmail:
            return "Email cannot be empty"
        case .invalidEmail:
            return "Invalid email format"
        case .emptyPhone:
            return "Phone cannot be empty"
        case .invalidPhone:
            return "Phone must contain only numbers"
        case .emptyPassword:
            return "Password cannot be empty"
        case .weakPassword:
            return "Password must be at least 6 characters"
        }
    }

    var field: RegisterField {
        switch self {
        case .emptyUsername:
            return .username
        case .emptyFirstName:
            return .firstName
        case .emptyLastName:
            return .lastName
        case .emptyEmail, .invalidEmail:
            return .email
        case .emptyPhone, .invalidPhone:
            return .phone
        case .emptyPassword, .weakPassword:
            return .password
        }
    }
}

enum RegisterField {
    case username
    case firstName
    case lastName
    case email
    case phone
    case password
}

protocol RegisterUserUseCase {
    func execute(username: String, firstName: String, lastName: String, email: String, phone: String, password: String) async -> Result<Void, Failure>
}

class RegisterUserInteractor: RegisterUserUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(username: String, firstName: String, lastName: String, email: String, phone: String, password: String) async -> Result<Void, Failure> {
        // Validate all inputs and collect errors
        if let validationError = validateInputs(
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: password
        ) {
            return .failure(.validationError(validationError.message))
        }

        // Call repository to register
        return await repository.register(
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: password
        )
    }

    private func validateInputs(username: String, firstName: String, lastName: String, email: String, phone: String, password: String) -> RegisterValidationError? {
        // Validate username
        if username.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyUsername
        }

        // Validate first name
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyFirstName
        }

        // Validate last name
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyLastName
        }

        // Validate email
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyEmail
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            return .invalidEmail
        }

        // Validate phone
        if phone.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyPhone
        }

        // Check if phone contains only numbers (and optionally + - () spaces)
        let phoneCharacterSet = CharacterSet(charactersIn: "0123456789+- ()")
        if phone.trimmingCharacters(in: phoneCharacterSet).count > 0 {
            return .invalidPhone
        }

        // Validate password
        if password.isEmpty {
            return .emptyPassword
        }

        if password.count < 6 {
            return .weakPassword
        }

        return nil
    }
}
