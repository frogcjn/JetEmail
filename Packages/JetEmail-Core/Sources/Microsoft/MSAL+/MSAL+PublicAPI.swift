//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Foundation
@preconcurrency import MSAL


// MARK: - Sign In

extension Client {
    
    public func signIn() async throws -> Session {
        try await SessionStore.shared.insert(msalSession: try await _msalSignIn(), forceReplacing: false)
    }
}

// MARK: - Sign Out

extension Session {
    
    // @MainActor // for SessionStore
    public func signOut() async throws -> Session {
        _ = try await Client.shared._msalSignout(msalAccount: _msalSession.account)
        _ = try await SessionStore.shared.remove(id: accountID)
        return self
    }
}

// MARK: - Sessions

extension Client {

    public var sessions: [Session] { get async throws {

        let ids = try _msalClient.allAccounts().map{ try $0.id }
        return try await withThrowingTaskGroup(of: Session.self) { group in
            for id in ids { group.addTask {
                try await SessionStore.shared.insert(id: id, forceReplacing: false)
            } }
            
            var sessions = [Session]()
            sessions.reserveCapacity(ids.count)
            for try await session in group {
                sessions.append(session)
            }
            return sessions
        }
    } }
}

// MARK: - Session Refresh If Expired


extension ID {
    public var sessionRefreshIfExpired: Session { get async throws {
        let session = try await SessionStore.shared.insert(id: self, forceReplacing: false)
        return try await session._refreshIfExpired
    } }
}

fileprivate extension Session {
    var isExpired: Bool {
        guard let expiresOn = _msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
    
    var _refreshIfExpired: Session { get async throws {
        if !isExpired { return self }
        return try await SessionStore.shared.insert(id: accountID, forceReplacing: true)
    } }
}

// MARK: - Authorization Header

public extension Session {
    var authorizationHeader: String { get async throws {
        try await _refreshIfExpired._msalSession.authorizationHeader
    } }
}
