//
//  MainHomeView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import SwiftUI

// MARK: - Main Content View with TabBar
struct MainHomeView: View {
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ReservationsTabView()
                .tabItem {
                    Label("My Reservations", systemImage: "calendar")
                }
            
            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

// MARK: - Home Tab with Navigation
struct HomeTabView: View {
    var body: some View {
        
        ReservationView()
        
    }
}

// MARK: - Reservations Tab with Navigation
struct ReservationsTabView: View {
    var body: some View {
       
        ReservationsView()
        
    }
}
struct ProfileTabView: View {
    var body: some View {
    
        ProfileView()
        
    }
}

struct ReservationsView: View {
    var body: some View {
        VStack {
            Text("My Reservations View")
                .font(.title)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Reservations")
    }
}
