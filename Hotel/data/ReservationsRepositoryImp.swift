//
//  ReservationsRepositoryImp.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//
import Foundation

class ReservationRepositoryImpl: ReservationsRepository {
    private let remoteDataSource: ReservationRemoteDataSource
    
    init(remoteDataSource: ReservationRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getUpcomingReservations(guestId: Int64) async -> Result<[Reservation], Failure> {
        do {
            let reservationsApi = try await remoteDataSource.getUpcomingReservations(guestId: guestId)
            let reservations = reservationsApi.map { $0.toDomain() }
            return .success(reservations)
        } catch let error as Failure {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func getPastReservations(guestId: Int64) async -> Result<[Reservation], Failure> {
        do {
            let reservationsApi = try await remoteDataSource.getPastReservations(guestId: guestId)
            let reservations = reservationsApi.map { $0.toDomain() }
            return .success(reservations)
        } catch let error as Failure {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

}
