//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import GTMAppAuth
import JetEmailData

import SwiftUI
import AuthenticationServices

// MARK: - Sessions

extension GoogleClient: ClientAPIProtocol {
    
    @MainActor // for SessionStore
    public var sessions: [GoogleSession] { get async throws { // the sessions should be refresh before using to fetch
        let items = try await Keychain.shared.items
        return items.map { SessionStore.shared.insert(sessionItem: $0, forceReplacing: false) }
    } }

    @MainActor // for WebAuthenticationSession
    public func signIn() async throws -> GoogleSession {
        let gtmSession = try await _gtmSignIn()
        let sessionItem = try await Keychain.shared.insertItem(gtmSession: gtmSession)
        return SessionStore.shared.insert(sessionItem: sessionItem, forceReplacing: false)
    }
}

// MARK: - Sign Out

extension GoogleSession : SessionProtocol {
    
    public func signOut() async throws -> GoogleSession {
        _ = try await Keychain.shared.deleteItem(_item)
        _ = await account.id.removeSession()
        return self
    }
}

// MARK: - AccountIDPublicAPI

@MainActor
extension GoogleAccountID : AccountSessionAPI {

    public var storedSession: GoogleSession? { SessionStore.shared[self] }
    public var refreshSession: GoogleSession? { get async throws {
        try await SessionStore.shared.session(id: self, forceRefresh: false)?.refresh
    } }
    public func removeSession() -> GoogleSession? { SessionStore.shared.remove(id: self) }
}

// MARK: - Refresh Session 
// used for request, refresh if neccessary

public extension GoogleSession {
    var refresh: GoogleSession { get async throws {
        _ = try await _gtmSession._refresh()
        return self
    } }
}
