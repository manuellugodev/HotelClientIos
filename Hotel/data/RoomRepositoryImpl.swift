//
//  RoomRepositoryImpl.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

class RoomRepositoryImpl:RoomRepository{
    
    private let remoteSourceRoom :RoomRemoteSource
    
    init(remoteSourceRoom: RoomRemoteSource) {
        self.remoteSourceRoom = remoteSourceRoom
    }
    func getRoomAvailables(checkIn: String, checkOut: String, guests: Int) async -> Result<[RoomHotel], Failure>{
        
        do {
            // Call remote data source
            let roomsSource = try await remoteSourceRoom.getRoomsAvailable(startDate: checkIn, endDate: checkOut, guests: guests)
            // Convert back to domain entity
            let resultRooms = toRoomsDomain(roomsSource: roomsSource)
            
            return .success(resultRooms)
            
        } catch let error as Failure {
            return .failure(error)
            
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    func toRoomsDomain(roomsSource:[RoomApi])-> [RoomHotel]{
        return roomsSource.map { roomApi in
            RoomHotel(
                id: Int64(roomApi.id),
                description: roomApi.description,
                roomType: roomApi.roomType,
                pathImage: roomApi.image,
                peopleQuantity: roomApi.capacity,
                price: roomApi.price
            )
        }
    }
    
}
