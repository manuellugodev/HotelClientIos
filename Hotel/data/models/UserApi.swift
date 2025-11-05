//
//  UserApi.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation
struct UserApi:Codable{
    let username:String
    let password:String
    let enabled:Bool
    let guestId:ProfileApi
}

extension UserApi{
    func toGetProfileData() throws -> Profile{
        let profile  = Profile(username: username, firstName: guestId.firstName, lastName: guestId.lastName, email: guestId.email, phone: guestId.phone, guestId: Int(guestId.guestId))
        
        return profile
    }
}
