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

    func makeReservation(guestId: Int64, roomId: Int64, startTime: String, endTime: String, total: Double) async -> Result<Void, Failure> {
        do {
            try await remoteDataSource.makeReservation(
                guestId: guestId,
                roomId: roomId,
                startTime: startTime,
                endTime: endTime,
                total: total
            )
            return .success(())
        } catch let error as Failure {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func deleteReservation(appointmentId: Int64) async -> Result<Void, Failure> {
        do {
            try await remoteDataSource.deleteReservation(appointmentId: appointmentId)
            return .success(())
        } catch let error as Failure {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

}
