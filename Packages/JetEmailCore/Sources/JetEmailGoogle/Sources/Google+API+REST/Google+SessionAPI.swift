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
        _ = await Self.removeSession(accountID: account.id)
        return self
    }
    
    // used for request, refresh if neccessary
    public var refresh: GoogleSession { get async throws {
        _ = try await _gtmSession._refresh()
        return self
    } }
    
    
    @MainActor
    public static func storedSession(accountID: GoogleAccountID) -> GoogleSession? { SessionStore.shared[accountID] }
    
    @MainActor
    public static func refreshSession(accountID: GoogleAccountID) async throws -> GoogleSession? {
        try await SessionStore.shared.session(id: accountID, forceRefresh: false)?.refresh
    }
    
    @MainActor
    public static func removeSession(accountID: GoogleAccountID) -> GoogleSession? { SessionStore.shared.remove(id: accountID) }
}
