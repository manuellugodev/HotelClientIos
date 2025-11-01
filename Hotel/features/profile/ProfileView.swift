//
//  ProfileView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import SwiftUI
struct ProfileView: View {
    @State private var name: String = "John Doe"
    @State private var email: String = "john.doe@email.com"
    @State private var phone: String = "+1 234 567 8900"
    
    var body: some View {
        VStack(spacing: 30) {
            // Profile Image
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                )
                .padding(.top, 40)
            
            // Profile Fields
            VStack(spacing: 20) {
                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                }
                
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                // Phone Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter your phone", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Logout Button
            Button(action: {
                // Logout action - to be implemented
                print("Logout tapped")
            }) {
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
    }
}

