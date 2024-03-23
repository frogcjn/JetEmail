//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL
import JetEmailData

// MARK: - SessionProtocol

extension MicrosoftSession : SessionProtocol {
    
    public func signOut() async throws -> MicrosoftSession {
        _ = try await MicrosoftClient.shared._msalSignout(msalAccount: _msalSession.account)
        _ = await Self.removeSession(accountID: account.id)
        return self
    }
    
    public var refresh: MicrosoftSession { get async throws {
        if !_isExpired { return self }
        return try await SessionStore.shared.session(id: account.id, forceRefresh: true)
    } }
    
    fileprivate var _isExpired: Bool {
        guard let expiresOn = _msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
    
    
    @MainActor
    public static func storedSession(accountID: MicrosoftAccountID) -> MicrosoftSession? { SessionStore.shared[accountID] }
    
    @MainActor
    public static func refreshSession(accountID: MicrosoftAccountID) async throws -> MicrosoftSession? {
        try await SessionStore.shared.session(id: accountID, forceRefresh: false).refresh
    }
    
    @MainActor
    public static func removeSession(accountID: MicrosoftAccountID) -> MicrosoftSession? { SessionStore.shared.remove(id: accountID) }
}

// MARK: - Authorization Header

public extension MicrosoftSession {
    var authorizationHeader: String { get async throws {
        try await refresh._msalSession.authorizationHeader
    } }
}
