//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import JetEmailData

// MARK: - Client Session API

extension GoogleClient : ClientAuthProtocol {
    @MainActor
    public var sessions: [GoogleSession] { get async throws {
        try await keychain.items.asyncMap { @MainActor sessionItem in
            let accountID = sessionItem.account.id
            let session = accountID.cachedSession ?? _insertSession(item: sessionItem)
            return try await _refresh(session: session)
        }
    } }

    @MainActor
    public func signIn() async throws -> GoogleSession {
        try await _signIn()
    }
}

// MARK: - Session API

extension GoogleSession : SessionAuthProtocol {
    public var refresh: GoogleSession { get async throws {
        try await client._refresh(session: self)
    } }
    
    @MainActor
    public func signOut() async throws -> GoogleSession {
        _ = try await client.keychain.deleteItem(_item)
        _ = account.id.removeSession()
        return self
    }
}

// MARK: - AccountID Session API

@MainActor
extension GoogleAccountID  : @retroactive AccountIDAuthProtocol {
    public var cachedSession: GoogleSession? {
        session
    }
    
    public var refreshSession: GoogleSession { get async throws  {
        try await GoogleClient.shared._refreshSession(accountID: self)
    } }
    
    public func removeSession() -> GoogleSession? {
        let session = self.session
        self.session = nil
        return session
    }
}
