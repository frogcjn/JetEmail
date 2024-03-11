//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Foundation
@preconcurrency import MSAL
import JetEmail_ID

// MARK: - Sessions

public extension Client {
    @MainActor
    var sessions: [Session] { get async throws { // the sessions should be refresh before using to fetch
        let msalAccounts = try _msalClient.allAccounts()
        return try await msalAccounts.asyncMap { try await SessionStore.shared.session(id: $0.id, forceRefresh: false) }
    } }
}

// MARK: - Sign In

public extension Client {
    func signIn() async throws -> Session {
        let msalSession = try await _msalSignIn()
        return try await SessionStore.shared.insert(msalSession: msalSession, forceReplacing: false)
    }
}

// MARK: - Sign Out

public extension Session {
    func signOut() async throws -> Session {
        _ = try await Client.shared._msalSignout(msalAccount: _msalSession.account)
        _ = await accountID.removeSession()
        return self
    }
}

// MARK: - Stored Session
// used for checking status

@MainActor
public extension MicrosoftAccountID {
    var storedSession: Session? { SessionStore.shared[self] }
}

// MARK: - Refresh Session
// used for request, refresh if neccessary

public extension MicrosoftAccountID {
    var refreshMicrosoftSession: Session { get async throws {
        let session = try await SessionStore.shared.session(id: self, forceRefresh: false)
        return try await session.refresh
    } }
}

public extension Session {
    var refresh: Session { get async throws {
        if !_isExpired { return self }
        return try await SessionStore.shared.session(id: accountID, forceRefresh: true)
    } }
}

fileprivate extension Session {
    var _isExpired: Bool {
        guard let expiresOn = _msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
}

// MARK: - Authorization Header

public extension Session {
    var authorizationHeader: String { get async throws {
        try await refresh._msalSession.authorizationHeader
    } }
}

// MARK: - Remove Session

@MainActor
public extension MicrosoftAccountID {
    func removeSession() -> Session? { SessionStore.shared.remove(id: self) }
}
