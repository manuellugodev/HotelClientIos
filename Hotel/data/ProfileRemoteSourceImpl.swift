//
//  ProfileRemoteSourceImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

class ProfileRemoteSourceImpl:ProfileRemoteSource{
    
    let networkManager:BaseNetworkManager
    
    init(networkManager: BaseNetworkManager) {
        self.networkManager = networkManager
    }
    func getProfileData(username: String) async throws -> UserApi {
        return try await networkManager.fetch(
            endpoint: "/user/\(username)"
            )
    }
    
    
}
