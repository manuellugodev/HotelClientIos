//
//  RoomApi.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

struct RoomApi: Codable {
    let id: Int
    let roomNumber: String
    let roomType: String
    let capacity: Int
    let description: String
    let price: Double
    let image: String
}
