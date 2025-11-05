//
//  MakeReservationsUseCase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

protocol MakeReservationUseCase {
    func execute(_ reservation: Reservation) async -> Result<Reservation, Failure>
}

class MakeReservationInteractor: MakeReservationUseCase {
    private let repository: ReservationsRepository
    
    init(repository: ReservationsRepository) {
        self.repository = repository
    }
    
    func execute(_ reservation: Reservation) async -> Result<Reservation, Failure> {
        // TODO: Implement makeReservation when needed
        return .failure(.unknown("makeReservation not implemented yet"))
    }
}
