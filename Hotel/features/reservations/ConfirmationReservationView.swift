//
//  ConfirmationReservationView.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import SwiftUI

struct ConfirmationReservationView: View {
    @StateObject private var viewModel: ConfirmationReservationViewModel
    @Environment(\.dismiss) private var dismiss

    init(room: RoomHotel, checkIn: Date, checkOut: Date) {
        _viewModel = StateObject(wrappedValue: DependencyContainer.shared.makeConfirmationReservationViewModel(
            room: room,
            checkIn: checkIn,
            checkOut: checkOut
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Room Image
                AsyncImage(url: URL(string: viewModel.room.pathImage)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 250)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 250)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 20) {
                    // Room Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.room.roomType)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(viewModel.room.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }

                    Divider()

                    // Dates
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Check-in")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(viewModel.formattedCheckIn)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Check-out")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(viewModel.formattedCheckOut)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                        }

                        HStack {
                            Text("\(viewModel.numberOfNights) night\(viewModel.numberOfNights > 1 ? "s" : "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(Int(viewModel.room.price)) / night")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Divider()

                    // Total Price
                    HStack {
                        Text("Total Price")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", viewModel.totalPrice))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .padding()

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }

                // Book Button
                Button(action: {
                    viewModel.bookReservation()
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Book Now")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading)
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Confirm Reservation")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Booking Successful!", isPresented: $viewModel.showSuccess) {
            Button("OK") { }
        } message: {
            Text("Your reservation has been confirmed successfully!")
        }
    }
}
