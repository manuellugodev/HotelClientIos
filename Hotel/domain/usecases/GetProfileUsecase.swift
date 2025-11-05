//
//  GetProfileUsecase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol GetProfileUsecase{
    func execute()async -> Result<Profile,Failure>
}
class GetProfileInteractor:GetProfileUsecase{
    private let repository:ProfileRepository
    private let tokenManager:TokenManager
    
    init(repository: ProfileRepository,tokenM:TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenM
    }
    func execute() async -> Result<Profile, Failure> {
        
        let username = tokenManager.getUsername() ?? ""
        let result = await repository.getProfile(username: username)
        
        return result
    }
    
    
}
