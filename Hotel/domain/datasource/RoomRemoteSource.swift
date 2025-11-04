//
//  RoomRemoteSource.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

protocol RoomRemoteSource{
    func getRoomsAvailable(startDate: String, endDate: String, guests: Int) async throws -> [RoomApi]
}
