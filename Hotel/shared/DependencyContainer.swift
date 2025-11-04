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
    
    private init() {
        self.networkManager = BaseNetworkManager(baseURL: "https://hotel.manuellugo.dev")
        self.roomRemoteSource = RoomRemoteSourceImpl()
    }
    
    func makeRoomsRepository() -> RoomRepository {
        return RoomRepositoryImpl(remoteSourceRoom: roomRemoteSource)
    }
    
    func makeGetRoomsAvailablesUseCase() -> GetRoomsAvailables {
        return GetRoomsAvailablesInteractor(repositoryRoom: makeRoomsRepository())
    }
    
    func makeRoomsViewModel() -> RoomsAvailableViewModel {
        return RoomsAvailableViewModel(source:makeGetRoomsAvailablesUseCase())
    }
}
