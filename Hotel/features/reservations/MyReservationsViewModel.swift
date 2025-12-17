//
//  MyReservationsViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

@MainActor
class MyReservationsViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var selectedTab: ReservationType = .upcoming
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var deletingReservationId: Int?

    nonisolated(unsafe) private let getReservationsUseCase: GetReservationsUseCase
    nonisolated(unsafe) private let deleteReservationUseCase: DeleteReservationUseCase

    nonisolated init(getReservationsUseCase: GetReservationsUseCase, deleteReservationUseCase: DeleteReservationUseCase) {
        self.getReservationsUseCase = getReservationsUseCase
        self.deleteReservationUseCase = deleteReservationUseCase
    }

    func loadReservations() {
        isLoading = true
        errorMessage = nil

        Task {
            let result = await getReservationsUseCase.execute(type: selectedTab)

            switch result {
            case .success(let reservations):
                self.reservations = reservations
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }
    }

    func switchTab(to tab: ReservationType) {
        selectedTab = tab
        loadReservations()
    }

    func deleteReservation(appointmentId: Int) {
        deletingReservationId = appointmentId
        errorMessage = nil

        Task {
            let result = await deleteReservationUseCase.execute(appointmentId: Int64(appointmentId))

            switch result {
            case .success:
                // Remove from local list
                self.reservations.removeAll { $0.id == appointmentId }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }

            self.deletingReservationId = nil
        }
    }
}
