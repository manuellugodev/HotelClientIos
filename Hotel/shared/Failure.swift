//
//  Failure.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/1/25.
//

import Foundation

enum Failure: Error {
    case serverError(String)
    case connectionError(String)
    case invalidData(String)
    case validationError(String)
    case unknown(String)
    
    var message: String {
        switch self {
        case .serverError(let msg),
             .connectionError(let msg),
             .invalidData(let msg),
             .validationError(let msg),
             .unknown(let msg):
            return msg
        }
    }
}
