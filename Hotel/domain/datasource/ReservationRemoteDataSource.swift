//
//  ReservationRemoteDataSource.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

protocol ReservationRemoteDataSource {
    func makeReservation(_ reservationModel: Reservation) async throws -> Reservation
}
