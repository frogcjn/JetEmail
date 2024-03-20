//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

// MARK: - SessionProtocol

import JetEmailData

extension GoogleSession : SessionProtocol {
    
    public func signOut() async throws -> GoogleSession {
        _ = try await Keychain.shared.deleteItem(_item)
        _ = await account.id.removeSession()
        return self
    }
    
    // used for request, refresh if neccessary
    public var refresh: GoogleSession { get async throws {
        _ = try await _gtmSession._refresh()
        return self
    } }
}
