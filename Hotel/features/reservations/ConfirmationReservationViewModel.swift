//
//  ConfirmationReservationViewModel.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

class ConfirmationReservationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccess = false

    private let makeReservationUseCase: MakeReservationUseCase
    let room: RoomHotel
    let checkIn: Date
    let checkOut: Date

    init(makeReservationUseCase: MakeReservationUseCase, room: RoomHotel, checkIn: Date, checkOut: Date) {
        self.makeReservationUseCase = makeReservationUseCase
        self.room = room
        self.checkIn = checkIn
        self.checkOut = checkOut
    }

    var totalPrice: Double {
        let nights = calculateNights()
        return room.price * Double(nights)
    }

    var formattedCheckIn: String {
        formatDate(checkIn)
    }

    var formattedCheckOut: String {
        formatDate(checkOut)
    }

    var numberOfNights: Int {
        calculateNights()
    }

    func bookReservation() {
        isLoading = true
        errorMessage = nil

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let startTime = dateFormatter.string(from: checkIn)
        let endTime = dateFormatter.string(from: checkOut)

        Task {
            let result = await makeReservationUseCase.execute(
                roomId: room.id,
                startTime: startTime,
                endTime: endTime,
                total: totalPrice
            )

            switch result {
            case .success:
                self.showSuccess = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }
    }

    private func calculateNights() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: checkIn, to: checkOut)
        return max(components.day ?? 1, 1)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
