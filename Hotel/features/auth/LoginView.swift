//
//  LoginView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeLoginViewModel()
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Logo/Title Section
                VStack(spacing: 8) {
                    Image(systemName: "building.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)

                    Text("Hotel App")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    Text("Welcome Back")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 40)

                // Login Form
                VStack(spacing: 16) {
                    // Username Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        TextField("Enter username", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disabled(viewModel.isLoading)
                    }

                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        SecureField("Enter password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(viewModel.isLoading)
                    }

                    // Error Message
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

                    // Login Button
                    Button(action: {
                        viewModel.onLoginSuccess = {
                            authManager.login()
                        }
                        viewModel.login()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            } else {
                                Text("Login")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading || viewModel.username.isEmpty || viewModel.password.isEmpty)
                    .opacity((viewModel.isLoading || viewModel.username.isEmpty || viewModel.password.isEmpty) ? 0.6 : 1.0)
                }
                .padding(.horizontal, 32)

                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
