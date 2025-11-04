//
//  LoginApi.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

// Request model
struct LoginRequest: Codable {
    let username: String
    let password: String
}

// Response model - matches the "data" field from API
struct LoginResponse: Codable {
    let token: String
    let errorMessage: String?
    let guestId: Int64
}
