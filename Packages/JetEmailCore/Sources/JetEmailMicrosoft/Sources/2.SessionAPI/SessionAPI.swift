//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import JetEmailData

// MARK: - Client-Session API

@MainActor
extension MicrosoftClient : ClientSessionAPI {
    public var sessions: [MicrosoftSession] { get async throws {
        try await _sessions()
    } }

    @MainActor
    public func signIn() async throws -> MicrosoftSession {
        try await _signIn()
    }
}

// MARK: - Session API

extension MicrosoftSession : SessionAPIProtocol {
    public typealias  SessionType = MicrosoftSession
    
    @MainActor
    public var refresh: SessionType { get async throws {
        try await client._refresh(session: self)
    } }
    
    @MainActor
    public func signOut() async throws -> SessionType {
        try await client._signOut(session: self)
    }
}

public extension MicrosoftSession {
    private var _authorizationHeader: String {
        _item.msalSession.authorizationHeader
    }
    
    var refreshAuthorizationHeader: String { get async throws {
        try await refresh._authorizationHeader
    } }
}

// MARK: - Account ID Session API

@MainActor
extension MicrosoftAccountID  : AccountIDSessionAPI {
    public var storedSession: MicrosoftSession? {
        session
    }
    
    public var refreshSession: MicrosoftSession { get async throws  {
        try await MicrosoftClient.shared._refreshSession(accountID: self)
    } }
    
    public func removeSession() -> MicrosoftSession? {
        let session = self.session
        self.session = nil
        return session
    }
}
