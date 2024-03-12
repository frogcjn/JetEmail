//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import GTMAppAuth
import JetEmailID

// MARK: - Sessions

public extension GoogleClient {
    
    @MainActor
    var sessions: [GoogleSession] { get async throws { // the sessions should be refresh before using to fetch
        let items = try await Keychain.shared.items
        return items.map { SessionStore.shared.insert(sessionItem: $0, forceReplacing: false) }
    } }
}

// MARK: - Sign In

public extension GoogleClient {
    func signIn() async throws -> GoogleSession {
        let gtmSession = try await _gtmSignIn()
        let sessionItem = try await Keychain.shared.insertItem(gtmSession: gtmSession)
        return await SessionStore.shared.insert(sessionItem: sessionItem, forceReplacing: false)
    }
}

// MARK: - Sign Out

public extension GoogleSession {
    func signOut() async throws -> GoogleSession {
        _ = try await Keychain.shared.deleteItem(_item)
        _ = await account.id.removeSession()
        return self
    }
}

// MARK: - Stored Session
// used for checking status

@MainActor
public extension GoogleAccountID {
    var storedSession: GoogleSession? { SessionStore.shared[self] }
}

// MARK: - Refresh Session 
// used for request, refresh if neccessary

public extension GoogleAccountID {
    var refreshGoogleSession: GoogleSession? { get async throws {
        try await SessionStore.shared.session(id: self, forceRefresh: false)?.refresh
    } }
}

public extension GoogleSession {
    var refresh: GoogleSession { get async throws {
        _ = try await _gtmSession._refresh()
        return self
    } }
}

// MARK: - Remove Session
@MainActor
public extension GoogleAccountID {
    func removeSession() -> GoogleSession? { SessionStore.shared.remove(id: self) }
}
