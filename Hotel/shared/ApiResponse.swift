//
//  ApiResponse.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation
import Foundation

// MARK: - Generic API Response
struct APIResponse<T: Codable>: Codable {
    let data: T
    let status: Int
    let message: String
    let errorType: String?
    let timeStamp: Int64
    
    enum CodingKeys: String, CodingKey {
        case data
        case status
        case message = "messsage"  // API typo
        case errorType
        case timeStamp
    }
}
