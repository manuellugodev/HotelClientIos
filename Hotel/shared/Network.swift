//
//  Network.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation

// MARK: - API Error
enum APIError: LocalizedError {
    case serverError(message: String, code: Int)
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .serverError(let message, let code):
            return "Server Error (\(code)): \(message)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
import Foundation

class BaseNetworkManager {
    
    let baseURL: String
    private let session: URLSession
    private let tokenManager: TokenManager
    
    init(
        baseURL: String,
        session: URLSession = .shared,
        tokenManager: TokenManager = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenManager = tokenManager
    }
    
    // MARK: - Generic Fetch with Authentication
    func fetch<T: Codable>(
        endpoint: String,
        queryItems: [URLQueryItem]? = nil,
        method: String = "GET",
        body: Data? = nil,
        headers: [String: String]? = nil,
        requiresAuth: Bool = true  // Flag to indicate if auth is needed
    ) async throws -> T {
        var components = URLComponents(string: "\(baseURL)\(endpoint)")!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        // Add default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication header if required
        if requiresAuth, let token = tokenManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Handle 401 Unauthorized - Token expired
            if httpResponse.statusCode == 401 {
                // Try to refresh token
                if try await refreshToken() {
                    // Retry the original request with new token
                    return try await fetch(
                        endpoint: endpoint,
                        queryItems: queryItems,
                        method: method,
                        body: body,
                        headers: headers,
                        requiresAuth: requiresAuth
                    )
                } else {
                    throw APIError.unauthorized
                }
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(
                    message: "HTTP \(httpResponse.statusCode)",
                    code: httpResponse.statusCode
                )
            }
            
            return try decodeResponse(data: data)
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Refresh Token
    private func refreshToken() async throws -> Bool {
        guard let refreshToken = tokenManager.getRefreshToken() else {
            return false
        }
        
        do {
            let response: RefreshTokenResponse = try await fetch(
                endpoint: "/auth/refresh",
                method: "POST",
                body: try? JSONEncoder().encode(["refreshToken": refreshToken]),
                requiresAuth: false  // Don't require auth for refresh endpoint
            )
            
            // Save new tokens
            tokenManager.saveToken(response.accessToken)
            if let newRefreshToken = response.refreshToken {
                tokenManager.saveRefreshToken(newRefreshToken)
            }
            
            return true
        } catch {
            // Refresh failed, clear tokens and require re-login
            tokenManager.clearAll()
            // Post notification to show login screen
            NotificationCenter.default.post(name: .userDidLogout, object: nil)
            return false
        }
    }
    
    // MARK: - Private Methods
    private func decodeResponse<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            // Try to decode as wrapped APIResponse first
            if let apiResponse = try? decoder.decode(APIResponse<T>.self, from: data) {
                guard apiResponse.status == 200 else {
                    throw APIError.serverError(
                        message: apiResponse.message,
                        code: apiResponse.status
                    )
                }
                return apiResponse.data
            }
            
            // If that fails, try direct decoding
            return try decoder.decode(T.self, from: data)
            
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        }
    }
}

// MARK: - Refresh Token Response Model
struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
}

// MARK: - API Error Extension
extension APIError {
    static let unauthorized = APIError.serverError(message: "Unauthorized", code: 401)
}

// MARK: - Notification Extension
extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}
