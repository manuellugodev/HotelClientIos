//
//  DeleteReservationUseCase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

protocol DeleteReservationUseCase {
    func execute(appointmentId: Int64) async -> Result<Void, Failure>
}

class DeleteReservationInteractor: DeleteReservationUseCase {
    private let repository: ReservationsRepository

    init(repository: ReservationsRepository) {
        self.repository = repository
    }

    func execute(appointmentId: Int64) async -> Result<Void, Failure> {
        return await repository.deleteReservation(appointmentId: appointmentId)
    }
}
