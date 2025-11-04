//
//  HotelApp.swift
//  Hotel
//
//  Created by Manuel Lugo on 10/25/25.
//

import SwiftUI

@main
struct HotelApp: App {
    @StateObject private var authManager = AuthenticationManager()

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainHomeView()
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
