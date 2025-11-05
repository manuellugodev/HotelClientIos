//
//  MyReservationsView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import SwiftUI

struct MyReservationsView: View {
    @StateObject private var viewModel: MyReservationsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: DependencyContainer.shared.makeMyReservationsViewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            // Tab Picker
            Picker("Reservation Type", selection: $viewModel.selectedTab) {
                Text("Upcoming").tag(ReservationType.upcoming)
                Text("Past").tag(ReservationType.past)
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: viewModel.selectedTab) { _, newValue in
                viewModel.switchTab(to: newValue)
            }

            // Content
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading reservations...")
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage, onRetry: {
                        viewModel.loadReservations()
                    })
                } else if viewModel.reservations.isEmpty {
                    EmptyReservationsView(type: viewModel.selectedTab)
                } else {
                    ReservationListView(
                        reservations: viewModel.reservations,
                        deletingReservationId: viewModel.deletingReservationId,
                        onDelete: viewModel.deleteReservation
                    )
                }
            }
        }
        .navigationTitle("My Reservations")
        .onAppear {
            viewModel.loadReservations()
        }
    }
}

// MARK: - Reservation List View
struct ReservationListView: View {
    let reservations: [Reservation]
    let deletingReservationId: Int?
    let onDelete: (Int) -> Void

    var body: some View {
        List {
            ForEach(reservations, id: \.id) { reservation in
                ReservationCardView(
                    reservation: reservation,
                    isDeleting: deletingReservationId == reservation.id
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        onDelete(reservation.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Reservation Card View
struct ReservationCardView: View {
    let reservation: Reservation
    let isDeleting: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Room Image
            AsyncImage(url: URL(string: reservation.roomHotel.pathImage)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        ProgressView()
                    }
                    .frame(height: 180)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                case .failure:
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 180)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(12)

            // Reservation Details
            VStack(alignment: .leading, spacing: 8) {
                // Room Type
                Text(reservation.roomHotel.roomType)
                    .font(.headline)
                    .foregroundColor(.primary)

                // Dates
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text(formatDateRange(checkIn: reservation.checkIn, checkOut: reservation.checkOut))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Guest Info
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                    Text("\(reservation.guest.firstName) \(reservation.guest.lastName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Price
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    Text(String(format: "$%.2f", reservation.totalPrice))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .opacity(isDeleting ? 0.5 : 1.0)
        .overlay(
            Group {
                if isDeleting {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        )
    }

    private func formatDateRange(checkIn: Int64, checkOut: Int64) -> String {
        let checkInDate = Date(timeIntervalSince1970: TimeInterval(checkIn / 1000))
        let checkOutDate = Date(timeIntervalSince1970: TimeInterval(checkOut / 1000))

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return "\(formatter.string(from: checkInDate)) - \(formatter.string(from: checkOutDate))"
    }
}

// MARK: - Empty State View
struct EmptyReservationsView: View {
    let type: ReservationType

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: type == .upcoming ? "calendar.badge.clock" : "calendar.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text(type == .upcoming ? "No Upcoming Reservations" : "No Past Reservations")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Text(type == .upcoming ? "You don't have any upcoming reservations yet." : "You don't have any past reservations.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Error")
                .font(.title2)
                .fontWeight(.medium)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: onRetry) {
                Text("Retry")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
