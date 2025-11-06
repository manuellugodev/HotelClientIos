//
//  RegisterView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/6/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeRegisterViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Logo/Title Section
                    VStack(spacing: 8) {
                        Image(systemName: "person.badge.plus.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)

                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Text("Join us today")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Registration Form
                    VStack(spacing: 16) {
                        // Username Field
                        FormFieldView(
                            label: "Username",
                            placeholder: "Enter username",
                            text: $viewModel.username,
                            error: viewModel.usernameError,
                            isDisabled: viewModel.isLoading
                        )

                        // First Name Field
                        FormFieldView(
                            label: "First Name",
                            placeholder: "Enter first name",
                            text: $viewModel.firstName,
                            error: viewModel.firstNameError,
                            isDisabled: viewModel.isLoading
                        )

                        // Last Name Field
                        FormFieldView(
                            label: "Last Name",
                            placeholder: "Enter last name",
                            text: $viewModel.lastName,
                            error: viewModel.lastNameError,
                            isDisabled: viewModel.isLoading
                        )

                        // Email Field
                        FormFieldView(
                            label: "Email",
                            placeholder: "Enter email",
                            text: $viewModel.email,
                            error: viewModel.emailError,
                            keyboardType: .emailAddress,
                            isDisabled: viewModel.isLoading
                        )

                        // Phone Field
                        FormFieldView(
                            label: "Phone",
                            placeholder: "Enter phone number",
                            text: $viewModel.phone,
                            error: viewModel.phoneError,
                            keyboardType: .phonePad,
                            isDisabled: viewModel.isLoading
                        )

                        // Password Field
                        SecureFormFieldView(
                            label: "Password",
                            placeholder: "Enter password",
                            text: $viewModel.password,
                            error: viewModel.passwordError,
                            isDisabled: viewModel.isLoading
                        )

                        // Confirm Password Field
                        SecureFormFieldView(
                            label: "Confirm Password",
                            placeholder: "Re-enter password",
                            text: $viewModel.confirmPassword,
                            error: viewModel.confirmPasswordError,
                            isDisabled: viewModel.isLoading
                        )

                        // General Error Message
                        if let errorMessage = viewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text(errorMessage)
                                    .font(.caption)
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(8)
                        }

                        // Register Button
                        Button(action: {
                            viewModel.register()
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                } else {
                                    Text("Register")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.isLoading || !viewModel.isFormValid)
                        .opacity((viewModel.isLoading || !viewModel.isFormValid) ? 0.6 : 1.0)

                        // Back to Login
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Already have an account? Login")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .underline()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Account created successfully! Please login with your credentials.")
        }
    }
}

// Reusable Form Field Component
struct FormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let error: String?
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)

            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(keyboardType)
                .disabled(isDisabled)

            if let error = error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(error)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.9))
                .cornerRadius(6)
            }
        }
    }
}

// Reusable Secure Form Field Component
struct SecureFormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let error: String?
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)

            SecureField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isDisabled)

            if let error = error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(error)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.9))
                .cornerRadius(6)
            }
        }
    }
}

#Preview {
    RegisterView()
}
