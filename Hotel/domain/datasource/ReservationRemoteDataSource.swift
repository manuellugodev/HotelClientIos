//
//  ReservationRemoteDataSource.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

protocol ReservationRemoteDataSource {
    func getUpcomingReservations(guestId: Int64) async throws -> [ReservationApi]
    func getPastReservations(guestId: Int64) async throws -> [ReservationApi]
}
