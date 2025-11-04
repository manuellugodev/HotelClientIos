//
//  RoomRemoteSourceImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

class RoomRemoteSourceImpl:RoomRemoteSource{
    
    private let baseURL = "https://hotel.manuellugo.dev"
    private let networkManager : BaseNetworkManager
       
    init(baseURL: String = "https://hotel.manuellugo.dev") {
            self.networkManager = BaseNetworkManager(baseURL: baseURL)
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
