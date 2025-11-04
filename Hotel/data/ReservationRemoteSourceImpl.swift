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
    
    func makeReservation(_ reservationModel: ReservationModel) async throws -> ReservationModel {
        // Build URL with query parameters
        guard var components = URLComponents(string: "\(baseURL)/appointment") else {
            throw Failure.invalidData("Invalid URL")
        }
        
        components.queryItems = [
            URLQueryItem(name: "guestId", value: reservationModel.guestId),
            URLQueryItem(name: "roomId", value: reservationModel.roomId),
            URLQueryItem(name: "startTime", value: reservationModel.startTime),
            URLQueryItem(name: "endTime", value: reservationModel.endTime),
            URLQueryItem(name: "purpose", value: reservationModel.purpose),
            URLQueryItem(name: "total", value: String(reservationModel.total))
        ]
        
        guard let url = components.url else {
            throw Failure.invalidData("Failed to construct URL")
        }
        
        // Create POST request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Execute request
        do {
            let (data, response) = try await session.data(for: request)
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw Failure.serverError("Invalid response")
            }
            
            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                // Success - decode response
                let decoder = JSONDecoder()
                do {
                    let reservationResponse = try decoder.decode(ReservationModel.self, from: data)
                    return reservationResponse
                } catch {
                    throw Failure.invalidData("Failed to decode response: \(error.localizedDescription)")
                }
                
            case 400...499:
                throw Failure.validationError("Client error: \(httpResponse.statusCode)")
                
            case 500...599:
                throw Failure.serverError("Server error: \(httpResponse.statusCode)")
                
            default:
                throw Failure.unknown("Unexpected status code: \(httpResponse.statusCode)")
            }
            
        } catch let error as Failure {
            throw error
        } catch {
            // Network or other errors
            throw Failure.connectionError("Network error: \(error.localizedDescription)")
        }
    }
}
