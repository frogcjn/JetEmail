//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Foundation
@preconcurrency import MSAL
import JetEmailID
import JetEmailFoundation

// MARK: - AccountID
// used for checking status

@MainActor
extension MicrosoftAccountID : AccountIDSessionAPI {
    public var storedSession: MicrosoftSession? { SessionStore.shared[self] }
    public var refreshSession: MicrosoftSession? { get async throws {
        let session = try await SessionStore.shared.session(id: self, forceRefresh: false)
        return try await session.refresh
    } }
    public func removeSession() -> MicrosoftSession? { SessionStore.shared.remove(id: self) }
}

// MARK: - Sessions

extension MicrosoftClient : ClientProtocol {
    @MainActor // for SessionStore
    public var sessions: [MicrosoftSession] { get async throws { // the sessions should be refresh before using to fetch
        let msalAccounts = try _msalClient.allAccounts()
        return try await msalAccounts.asyncMap {@MainActor in try await SessionStore.shared.session(id: $0.id, forceRefresh: false) }
    } }

    @MainActor
    public func signIn() async throws -> MicrosoftSession {
        let msalSession = try await _msalSignIn()
        return try SessionStore.shared.insert(msalSession: msalSession, forceReplacing: false)
    }
}

// MARK: - Sign Out

extension MicrosoftSession : SessionProtocol {
    
    public func signOut() async throws -> MicrosoftSession {
        _ = try await MicrosoftClient.shared._msalSignout(msalAccount: _msalSession.account)
        _ = await account.id.removeSession()
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
    
}

// MARK: - Authorization Header

public extension MicrosoftSession {
    var authorizationHeader: String { get async throws {
        try await refresh._msalSession.authorizationHeader
    } }
}

