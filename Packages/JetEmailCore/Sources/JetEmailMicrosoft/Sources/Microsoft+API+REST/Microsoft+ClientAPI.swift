//
//  File 2.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

// MARK: - ClientProtocol

import JetEmailData
@preconcurrency import MSAL

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
