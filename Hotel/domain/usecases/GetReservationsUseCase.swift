//
//  GetReservationsUseCase.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

enum ReservationType {
    case upcoming
    case past
}

protocol GetReservationsUseCase {
    func execute(type: ReservationType) async -> Result<[Reservation], Failure>
}

class GetReservationsInteractor: GetReservationsUseCase {
    private let repository: ReservationsRepository
    private let tokenManager: TokenManager

    init(repository: ReservationsRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
    }

    func execute(type: ReservationType) async -> Result<[Reservation], Failure> {
        guard let guestId = tokenManager.getGuestId() else {
            return .failure(.invalidData("Guest ID not found"))
        }

        switch type {
        case .upcoming:
            return await repository.getUpcomingReservations(guestId: guestId)
        case .past:
            return await repository.getPastReservations(guestId: guestId)
        }
    }
}
