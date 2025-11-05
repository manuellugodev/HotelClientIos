//
//  ReservationApi.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

struct ReservationApi: Codable {
    let appointmentId: Int
    let guest: CustomerApi
    let room: RoomApi
    let startTime: String
    let endTime: String
    let purpose: String
    let total: Double
    let status: String?

    enum CodingKeys: String, CodingKey {
        case appointmentId
        case guest
        case room
        case startTime
        case endTime
        case purpose
        case total
        case status
    }

    // Convert API model to domain model
    func toDomain() -> Reservation {
        // Convert date strings to timestamps (milliseconds)
        let checkInTimestamp = dateStringToTimestamp(startTime)
        let checkOutTimestamp = dateStringToTimestamp(endTime)

        return Reservation(
            id: appointmentId,
            guest: guest.toDomain(),
            roomHotel: room.toDomain(),
            checkIn: checkInTimestamp,
            checkOut: checkOutTimestamp,
            purpose: purpose,
            price: total,
            taxPrice: 0.0, // API doesn't provide tax breakdown
            totalPrice: total
        )
    }

    private func dateStringToTimestamp(_ dateString: String) -> Int64 {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")

        if let date = formatter.date(from: dateString) {
            return Int64(date.timeIntervalSince1970 * 1000) // Convert to milliseconds
        }
        return 0
    }
}
