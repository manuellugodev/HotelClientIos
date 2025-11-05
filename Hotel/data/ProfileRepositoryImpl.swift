//
//  ProfileRepositoryImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

class ProfileRepositoryImpl:ProfileRepository{
    
    private let remoteSource:ProfileRemoteSource
    
    init(remoteSource: ProfileRemoteSource) {
        self.remoteSource = remoteSource
    }
    func getProfile(username: String) async -> Result<Profile, Failure> {

        do {
            let profileResult = try await remoteSource.getProfileData(username:username)
            
            return .success(try profileResult.toGetProfileData())
        }catch let error as Failure{
            return .failure(error)
        }catch{
            return .failure(.unknown(error.localizedDescription))
        }

    }
    
    
}
