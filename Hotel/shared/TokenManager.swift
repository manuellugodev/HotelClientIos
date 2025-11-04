//
//  TokenManager.swift
//  Hotel
//
//  Created by Manuel Lugo on 11/3/25.
//

import Foundation
import Security

class TokenManager {
    
    static let shared = TokenManager()
    
    private let service = "com.hotel.app"
    private let tokenKey = "authToken"
    private let refreshTokenKey = "refreshToken"
    
    private init() {
        saveToken("sada")
    }
    
    // MARK: - Save Token
    func saveToken(_ token: String) {
        save(token, forKey: tokenKey)
    }
    
    func saveRefreshToken(_ token: String) {
        save(token, forKey: refreshTokenKey)
    }
    
    // MARK: - Get Token
    func getToken() -> String? {
        return retrieve(forKey: tokenKey)
    }
    
    func getRefreshToken() -> String? {
        return retrieve(forKey: refreshTokenKey)
    }
    
    // MARK: - Delete Token
    func deleteToken() {
        delete(forKey: tokenKey)
    }
    
    func deleteRefreshToken() {
        delete(forKey: refreshTokenKey)
    }
    
    func clearAll() {
        deleteToken()
        deleteRefreshToken()
    }
    
    // MARK: - Private Methods
    private func save(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete old value if exists
        SecItemDelete(query as CFDictionary)
        
        // Add new value
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
