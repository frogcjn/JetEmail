//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

// MARK: - ClientProtocol

@preconcurrency import GTMAppAuth
import JetEmailData

extension GoogleClient: ClientProtocol {
    
    @MainActor // for SessionStore
    public var sessions: [GoogleSession] { get async throws { // the sessions should be refresh before using to fetch
        let items = try await Keychain.shared.items
        return items.map { SessionStore.shared.insert(sessionItem: $0, forceReplacing: false) }
    } }

    @MainActor // for WebAuthenticationSession
    public func signIn() async throws -> GoogleSession {
        let gtmSession  = try await _gtmSignIn()
        let sessionItem = try await Keychain.shared.insertItem(gtmSession: gtmSession)
        return SessionStore.shared.insert(sessionItem: sessionItem, forceReplacing: false)
    }
}
