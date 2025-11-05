//
//  DependencyContainer.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation
class DependencyContainer {

    static let shared = DependencyContainer()

    private let networkManager: BaseNetworkManager
    private let roomRemoteSource: RoomRemoteSource
    private let authRemoteDataSource: AuthRemoteDataSource
    private let profileRemoteSource: ProfileRemoteSource
    private let reservationRemoteDataSource: ReservationRemoteDataSource

    private init() {
        self.networkManager = BaseNetworkManager(baseURL: "https://hotel.manuellugo.dev")
        self.roomRemoteSource = RoomRemoteSourceImpl(networkManager: networkManager)
        self.authRemoteDataSource = AuthRemoteDataSourceImpl(networkManager: networkManager)
        self.profileRemoteSource = ProfileRemoteSourceImpl(networkManager: networkManager)
        self.reservationRemoteDataSource = ReservationRemoteDataSourceImpl(session: .shared)
    }

    // MARK: - Rooms
    func makeRoomsRepository() -> RoomRepository {
        return RoomRepositoryImpl(remoteSourceRoom: roomRemoteSource)
    }

    func makeGetRoomsAvailablesUseCase() -> GetRoomsAvailables {
        return GetRoomsAvailablesInteractor(repositoryRoom: makeRoomsRepository())
    }

    func makeRoomsViewModel(checkIn: Date, checkOut: Date, guests: Int) -> RoomsAvailableViewModel {
        return RoomsAvailableViewModel(
            source: makeGetRoomsAvailablesUseCase(),
            checkIn: checkIn,
            checkOut: checkOut,
            guests: guests
        )
    }

    // MARK: - Authentication
    func makeAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(remoteDataSource: authRemoteDataSource)
    }

    func makeLoginUseCase() -> LoginUseCase {
        return LoginInteractor(repository: makeAuthRepository())
    }

    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: makeLoginUseCase())
    }
    func makeProfileViewModel() -> ProfileViewModel{
        return ProfileViewModel(usecase:makeGetProfileUseCase())
    }
    
    func makeGetProfileUseCase() -> GetProfileUsecase{
        return GetProfileInteractor(repository: makeProfileRepository())
    }
    func makeProfileRepository() -> ProfileRepository{
        return ProfileRepositoryImpl(remoteSource:profileRemoteSource)
    }

    // MARK: - Reservations
    func makeReservationsRepository() -> ReservationsRepository {
        return ReservationRepositoryImpl(remoteDataSource: reservationRemoteDataSource)
    }

    func makeGetReservationsUseCase() -> GetReservationsUseCase {
        return GetReservationsInteractor(repository: makeReservationsRepository())
    }

    func makeDeleteReservationUseCase() -> DeleteReservationUseCase {
        return DeleteReservationInteractor(repository: makeReservationsRepository())
    }

    func makeMyReservationsViewModel() -> MyReservationsViewModel {
        return MyReservationsViewModel(
            getReservationsUseCase: makeGetReservationsUseCase(),
            deleteReservationUseCase: makeDeleteReservationUseCase()
        )
    }

    func makeMakeReservationUseCase() -> MakeReservationUseCase {
        return MakeReservationInteractor(repository: makeReservationsRepository())
    }

    func makeConfirmationReservationViewModel(room: RoomHotel, checkIn: Date, checkOut: Date) -> ConfirmationReservationViewModel {
        return ConfirmationReservationViewModel(
            makeReservationUseCase: makeMakeReservationUseCase(),
            room: room,
            checkIn: checkIn,
            checkOut: checkOut
        )
    }

}
