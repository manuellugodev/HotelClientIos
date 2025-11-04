//
//  AuthenticationManager.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation
import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated: Bool = false

    private let tokenManager: TokenManager

    init(tokenManager: TokenManager = .shared) {
        self.tokenManager = tokenManager
        // Check if user has a valid token on init
        self.isAuthenticated = tokenManager.getToken() != nil
    }

    func login() {
        isAuthenticated = true
    }

    func logout() {
        tokenManager.clearAll()
        isAuthenticated = false
    }
}
