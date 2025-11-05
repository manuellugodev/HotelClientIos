//
//  ProfileApi.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation
//

import Foundation
struct ProfileApi:Codable{
    let firstName:String
    let lastName:String
    let email:String
    let phone: String
    let guestId:Int64
}
