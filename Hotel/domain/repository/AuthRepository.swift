//
//  AuthRepository.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/4/25.
//

import Foundation

protocol AuthRepository {
    func login(username: String, password: String) async -> Result<User, Failure>
    func register(username: String, firstName: String, lastName: String, email: String, phone: String, password: String) async -> Result<Void, Failure>
}
