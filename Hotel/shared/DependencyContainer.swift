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

    private init() {
        self.networkManager = BaseNetworkManager(baseURL: "https://hotel.manuellugo.dev")
        self.roomRemoteSource = RoomRemoteSourceImpl(networkManager: networkManager)
        self.authRemoteDataSource = AuthRemoteDataSourceImpl(networkManager: networkManager)
    }

    // MARK: - Rooms
    func makeRoomsRepository() -> RoomRepository {
        return RoomRepositoryImpl(remoteSourceRoom: roomRemoteSource)
    }

    func makeGetRoomsAvailablesUseCase() -> GetRoomsAvailables {
        return GetRoomsAvailablesInteractor(repositoryRoom: makeRoomsRepository())
    }

    func makeRoomsViewModel() -> RoomsAvailableViewModel {
        return RoomsAvailableViewModel(source:makeGetRoomsAvailablesUseCase())
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
}
