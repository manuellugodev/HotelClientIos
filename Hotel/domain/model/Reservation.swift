//
//  Reservation.swift
//  Hotel
//
//  Created by Manuel Lugo on 10/29/25.
//

import Foundation

struct Reservation{
    let id:Int
    let guest:Customer
    let roomHotel:RoomHotel
    let checkIn:Int64
    let checkOut:Int64
    let purpose:String
    let price:Double
    let taxPrice:Double
    let totalPrice:Double
}
