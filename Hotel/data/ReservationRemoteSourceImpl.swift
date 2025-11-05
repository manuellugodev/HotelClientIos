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
}
