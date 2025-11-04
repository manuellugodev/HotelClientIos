//
//  AuthRepository.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol AuthRepository {
    func login(username: String, password: String) async -> Result<User, Failure>
}
