//
//  ProfileView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import SwiftUI
struct ProfileView: View {
    
    @StateObject private var vm = ProfileViewModel()
    var body: some View {
        VStack(spacing: 30) {
            if(!vm.showLoader){
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
                    TextField("Enter your name", text: $vm.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                        .disabled(true)
                }
                
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter your email", text: $vm.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disabled(true)
                }
                
                // Phone Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter your phone", text: $vm.phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                        .disabled(true)
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
                
            }else{
                ProgressView("Loading Profile")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
        }
        .navigationTitle("Profile")        
        .background(Color(.systemGroupedBackground))

    }
}

