//
//  ReservationRemoteSource.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation
//
//  ReservationRemoteDataSourceImpl.swift
//  Data Layer - Remote Data Source Implementation
//
//  This implements the actual API calls using URLSession
//

import Foundation

class ReservationRemoteDataSourceImpl: ReservationRemoteDataSource {
    private let baseURL = "https://hotel.manuellugo.dev"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func getUpcomingReservations(guestId: Int64) async throws -> [ReservationApi] {
        let today = ISO8601DateFormatter().string(from: Date())

        let networkManager = BaseNetworkManager(baseURL: baseURL, session: session)

        do {
            let reservations: [ReservationApi] = try await networkManager.fetch(
                endpoint: "/appointment/guest/\(guestId)/upcoming",
                queryItems: [
                    URLQueryItem(name: "dStartTime", value: today)
                ]
            )
            return reservations
        } catch let error as APIError {
            // If 404 (AppointmentNotFoundException), return empty array (no reservations is not an error)
            if case .serverError(_, let code) = error, code == 404 {
                return []
            }
            throw error
        } catch {
            throw error
        }
    }

    func getPastReservations(guestId: Int64) async throws -> [ReservationApi] {
        let today = ISO8601DateFormatter().string(from: Date())

        let networkManager = BaseNetworkManager(baseURL: baseURL, session: session)

        do {
            let reservations: [ReservationApi] = try await networkManager.fetch(
                endpoint: "/appointment/guest/\(guestId)/past",
                queryItems: [
                    URLQueryItem(name: "dStartTime", value: today)
                ]
            )
            return reservations
        } catch let error as APIError {
            // If 404 (AppointmentNotFoundException), return empty array (no reservations is not an error)
            if case .serverError(_, let code) = error, code == 404 {
                return []
            }
            throw error
        } catch {
            throw error
        }
    }

    func makeReservation(guestId: Int64, roomId: Int64, startTime: String, endTime: String, total: Double) async throws {
        let networkManager = BaseNetworkManager(baseURL: baseURL, session: session)

        // API returns plain text "Appointment made successfully", so we decode as String and ignore it
        let _: String = try await networkManager.fetch(
            endpoint: "/appointment",
            queryItems: [
                URLQueryItem(name: "guestId", value: String(guestId)),
                URLQueryItem(name: "roomId", value: String(roomId)),
                URLQueryItem(name: "startTime", value: startTime),
                URLQueryItem(name: "endTime", value: endTime),
                URLQueryItem(name: "purpose", value: "Travel"),
                URLQueryItem(name: "total", value: String(total))
            ],
            method: "POST"
        )
        // Success if no error was thrown
    }

    func deleteReservation(appointmentId: Int64) async throws {
        let networkManager = BaseNetworkManager(baseURL: baseURL, session: session)

        // API returns success message, so we decode as String and ignore it
        let _: String = try await networkManager.fetch(
            endpoint: "/appointment",
            queryItems: [
                URLQueryItem(name: "id", value: String(appointmentId))
            ],
            method: "DELETE"
        )
        // Success if no error was thrown
    }
}
