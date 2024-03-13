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

// MARK: - Sessions

public extension MicrosoftClient {
    @MainActor
    var sessions: [MicrosoftSession] { get async throws { // the sessions should be refresh before using to fetch
        let msalAccounts = try _msalClient.allAccounts()
        return try await msalAccounts.asyncMap { try await SessionStore.shared.session(id: $0.id, forceRefresh: false) }
    } }
}

// MARK: - Sign In

public extension MicrosoftClient {
    @MainActor
    func signIn() async throws -> MicrosoftSession {
        let msalSession = try await _msalSignIn()
        return try SessionStore.shared.insert(msalSession: msalSession, forceReplacing: false)
    }
}

// MARK: - Sign Out

public extension MicrosoftSession {
    func signOut() async throws -> MicrosoftSession {
        _ = try await MicrosoftClient.shared._msalSignout(msalAccount: _msalSession.account)
        _ = await account.id.removeSession()
        return self
    }
}

// MARK: - Stored Session
// used for checking status

@MainActor
public extension MicrosoftAccountID {
    var storedSession: MicrosoftSession? { SessionStore.shared[self] }
}

// MARK: - Refresh Session
// used for request, refresh if neccessary

public extension MicrosoftAccountID {
    var refreshMicrosoftSession: MicrosoftSession { get async throws {
        let session = try await SessionStore.shared.session(id: self, forceRefresh: false)
        return try await session.refresh
    } }
}

public extension MicrosoftSession {
    var refresh: MicrosoftSession { get async throws {
        if !_isExpired { return self }
        return try await SessionStore.shared.session(id: account.id, forceRefresh: true)
    } }
}

fileprivate extension MicrosoftSession {
    var _isExpired: Bool {
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

// MARK: - Remove Session

@MainActor
public extension MicrosoftAccountID {
    func removeSession() -> MicrosoftSession? { SessionStore.shared.remove(id: self) }
}
