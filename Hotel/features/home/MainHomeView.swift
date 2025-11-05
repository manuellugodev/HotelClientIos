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
            
            NavigationStack(){
                HomeTabView()
            }.tabItem { Label("Home", systemImage: "house.fill")}
          
            
            NavigationStack(){
                ReservationsTabView()
            }.tabItem {
                Label("My Reservations", systemImage: "calendar")
            }
                
            NavigationStack(){
                ProfileTabView()
            }.tabItem {
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

        MyReservationsView()

    }
}
struct ProfileTabView: View {
    var body: some View {

        ProfileView()
    }
}
