//
//  ReservationsRepository.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

import Foundation

protocol ReservationsRepository {
    func makeReservation(_ reservation: Reservation) async -> Result<Reservation, Failure>
}
