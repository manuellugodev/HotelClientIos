//
//  AuthRemoteDataSource.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol AuthRemoteDataSource {
    func login(username: String, password: String) async throws -> LoginResponse
}
