//
//  ProfileRepository.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol ProfileRepository{
    func getProfile(username:String) async -> Result<Profile,Failure>
}
