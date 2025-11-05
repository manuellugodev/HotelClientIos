//
//  ReservationsRepository.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

protocol ReservationsRepository {
    func getUpcomingReservations(guestId: Int64) async -> Result<[Reservation], Failure>
    func getPastReservations(guestId: Int64) async -> Result<[Reservation], Failure>
    func makeReservation(guestId: Int64, roomId: Int64, startTime: String, endTime: String, total: Double) async -> Result<Void, Failure>
}
