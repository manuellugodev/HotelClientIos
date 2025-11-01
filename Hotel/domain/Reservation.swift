//
//  Reservation.swift
//  Hotel
//
//  Created by Manuel Lugo on 10/29/25.
//

import Foundation

struct Reservation{
    let id:Int
    let client:Customer
    let roomHotel:RoomHotel
    let checkIn:Int64
    let checkOut:Int64
    let price:Double
    let taxPrice:Double
    let totalPrice:Double
}
