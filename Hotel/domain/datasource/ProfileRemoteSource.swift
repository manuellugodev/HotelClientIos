//
//  ProfileRemoteSource.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol ProfileRemoteSource{
    func getProfileData(username:String)async throws -> UserApi
}
