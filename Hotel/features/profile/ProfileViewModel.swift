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
    @Published var showError = false
    private let getProfile:GetProfileUsecase
    
    var onLogout: (() -> Void)?
    
    init(usecase:GetProfileUsecase) {
        getProfile=usecase
    }
    
    func loadProfile(){
        
        Task{
            let result = await getProfile.execute()
            
            switch result {
            case .success(let success):
                self.name = "\(success.firstName) \(success.lastName)"
                self.phone = success.phone
                self.email = success.email
            case .failure(let failure):
                showError=true
            }
            showLoader=false
        }
    }
    
  
    
    func refreshDataProfile(){
        showLoader = true
        loadProfile()
    }
    
    func logout() {
        showLogoutAlert = true
    }

    func confirmLogout() {
        print("User logged out")
        onLogout?()
    }

}

