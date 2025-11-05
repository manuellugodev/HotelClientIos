//
//  MyReservationsViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

class MyReservationsViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var selectedTab: ReservationType = .upcoming
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getReservationsUseCase: GetReservationsUseCase

    init(getReservationsUseCase: GetReservationsUseCase) {
        self.getReservationsUseCase = getReservationsUseCase
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
}
