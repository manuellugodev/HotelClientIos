//
//  RoomRepository.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

protocol RoomRepository{
    
    func getRoomAvailables(checkIn:String,checkOut:String,guests:Int) async -> Result<[RoomHotel], Failure>
}
