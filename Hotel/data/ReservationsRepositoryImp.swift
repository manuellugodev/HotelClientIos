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
    
    func makeReservation(_ reservation: Reservation) async -> Result<Reservation, Failure> {
        // Convert domain entity to data model
        let reservationModel = ReservationModel.fromDomain(reservation)
        
        do {
            // Call remote data source
            let resultModel = try await remoteDataSource.makeReservation(reservationModel)
            
            // Convert back to domain entity
            let resultReservation = resultModel.toDomain()
            
            return .success(resultReservation)
            
        } catch let error as Failure {
            return .failure(error)
            
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
}
