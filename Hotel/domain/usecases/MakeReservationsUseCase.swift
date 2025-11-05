//
//  MakeReservationsUseCase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

protocol MakeReservationUseCase {
    func execute(roomId: Int64, startTime: String, endTime: String, total: Double) async -> Result<Void, Failure>
}

class MakeReservationInteractor: MakeReservationUseCase {
    private let repository: ReservationsRepository
    private let tokenManager: TokenManager

    init(repository: ReservationsRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
    }

    func execute(roomId: Int64, startTime: String, endTime: String, total: Double) async -> Result<Void, Failure> {
        guard let guestId = tokenManager.getGuestId() else {
            return .failure(.invalidData("Guest ID not found"))
        }

        return await repository.makeReservation(
            guestId: guestId,
            roomId: roomId,
            startTime: startTime,
            endTime: endTime,
            total: total
        )
    }
}
