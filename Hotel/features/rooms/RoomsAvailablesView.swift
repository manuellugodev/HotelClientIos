//
//  ReservationsAvailable.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import SwiftUI


// MARK: - ViewModel
// MARK: - Main View
struct RoomsAvailableView: View {
    let checkIn: Date
    let checkOut: Date
    let guests: Int

    @StateObject private var viewModel: RoomsAvailableViewModel
    @Environment(\.dismiss) private var dismiss

    init(checkIn: Date, checkOut: Date, guests: Int) {
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.guests = guests
        _viewModel = StateObject(wrappedValue: DependencyContainer.shared.makeRoomsViewModel(
            checkIn: checkIn,
            checkOut: checkOut,
            guests: guests
        ))
    }

    var body: some View {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading rooms...")
                } else {
                    RoomListView(
                        rooms: viewModel.rooms,
                        checkIn: checkIn,
                        checkOut: checkOut,
                        onRoomSelected: viewModel.selectRoom
                    )
                }
            }
            .navigationTitle("Available Rooms")
            .navigationDestination(isPresented: $viewModel.showConfirmation) {
                if let room = viewModel.selectedRoom {
                    ConfirmationReservationView(
                        room: room,
                        checkIn: viewModel.checkInDate,
                        checkOut: viewModel.checkOutDate
                    )
                }
            }
            .onAppear {
                viewModel.loadRooms()
            }
    }
}
// MARK: - Room List View (Isolated)
struct RoomListView: View {
    let rooms: [RoomHotel]
    let checkIn: Date
    let checkOut: Date
    let onRoomSelected: (RoomHotel) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(rooms, id: \.id) { room in
                    RoomCardView(room: room, checkIn: checkIn, checkOut: checkOut)
                        .onTapGesture {
                            onRoomSelected(room)
                        }
                }
            }
            .padding()
        }
    }
}

// MARK: - Room Card View (Isolated)
struct RoomCardView: View {
    let room: RoomHotel
    let checkIn: Date
    let checkOut: Date

    private var numberOfNights: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: checkIn, to: checkOut)
        return max(components.day ?? 1, 1)
    }

    private var totalPrice: Double {
        return room.price * Double(numberOfNights)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section - Remote Image Loading
            AsyncImage(url: URL(string: room.pathImage)) { phase in
                switch phase {
                case .empty:
                    // Loading state
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                    .frame(height: 200)

                case .success(let image):
                    // Successfully loaded image
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()

                case .failure:
                    // Failed to load - show fallback
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                        Image(systemName: "bed.double.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    .frame(height: 200)

                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)
            .clipped()
            
            // Details Section
            VStack(alignment: .leading, spacing: 8) {
                Text(room.roomType)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(room.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label("\(room.peopleQuantity) persons", systemImage: "person.2.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("$\(String(format: "%.2f", totalPrice))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
