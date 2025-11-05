//
//  CustomerApi.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/5/25.
//

import Foundation

struct CustomerApi: Codable {
    let guestId: Int
    let firstName: String
    let lastName: String
    let email: String
    let phone: String

    enum CodingKeys: String, CodingKey {
        case guestId
        case firstName
        case lastName
        case email
        case phone
    }

    // Convert API model to domain model
    func toDomain() -> Customer {
        return Customer(
            id: guestId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone
        )
    }
}
