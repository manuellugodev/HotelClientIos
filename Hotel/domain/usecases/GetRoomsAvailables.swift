//
//  GetRoomsAvailables.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation
protocol GetRoomsAvailables{
    func execute(_ checkIn:String,_ checkOut:String, _ guests:Int) async -> Result <[RoomHotel],Failure>
}

class GetRoomsAvailablesInteractor: GetRoomsAvailables{
    private let repositoryRoom:RoomRepository
    
    init(repositoryRoom: RoomRepository) {
        self.repositoryRoom = repositoryRoom
    }
    func execute(_ checkIn: String, _ checkOut: String, _ guests: Int) async -> Result<[RoomHotel], Failure> {
        return await repositoryRoom.getRoomAvailables(checkIn: checkIn, checkOut: checkOut, guests: guests)
    }

    
}
