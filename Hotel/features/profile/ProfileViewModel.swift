//
//  ProfileViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

class ProfileViewModel:ObservableObject{
      @Published var name: String = ""
      @Published var email: String = ""
      @Published var phone: String = ""
      @Published var showLogoutAlert: Bool = false
      @Published var showLoader = true

    var onLogout: (() -> Void)?

    init() {
        loadProfile()
    }

    func loadProfile(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.name = "Manuel Lugo"
            self.email = "manuellugo2000ml@gmail.com"
            self.phone = "1 234 567 8900"
            self.showLoader = false
        }
    }


      func logout() {
          showLogoutAlert = true
      }

      func confirmLogout() {
          print("User logged out")
          onLogout?()
      }
  }
