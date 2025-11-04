//
//  RoomRemoteSourceImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

class RoomRemoteSourceImpl:RoomRemoteSource{

    private let networkManager : BaseNetworkManager

    init(networkManager: BaseNetworkManager) {
        self.networkManager = networkManager
    }
        
    
    func getRoomsAvailable(startDate: String, endDate: String, guests: Int) async throws -> [RoomApi] {
        return try await networkManager.fetch(
            endpoint: "/rooms",
            queryItems: [
                URLQueryItem(name: "dStartTime", value: startDate),
                URLQueryItem(name: "dEndTime", value: endDate),
                URLQueryItem(name: "guests", value: "\(guests)")
            ])
    }
   }
