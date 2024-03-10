//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import GTMAppAuth
import JetEmail_Foundation

// MARK: - Sessions

public extension Client {
    
    @MainActor
    var sessions: [Session] { get async throws { // the sessions should be refresh before using to fetch
        let items = try await Keychain.shared.items
        return items.map { SessionStore.shared.insert(sessionItem: $0, forceReplacing: false) }
    } }
}

// MARK: - Sign In

public extension Google.Client {
    func signIn() async throws -> Google.Session {
        let gtmSession = try await _gtmSignIn()
        let sessionItem = try await Keychain.shared.insertItem(gtmSession: gtmSession)
        return await SessionStore.shared.insert(sessionItem: sessionItem, forceReplacing: false)
    }
}

// MARK: - Sign Out

public extension Google.Session {
    func signOut() async throws -> Google.Session {
        _ = try await Keychain.shared.deleteItem(_item)
        _ = await accountID.removeSession()
        return self
    }
}

// MARK: - Stored Session
// used for checking status

@MainActor
public extension GoogleAccountID {
    var storedSession: Session? { SessionStore.shared[self] }
}

// MARK: - Refresh Session 
// used for request, refresh if neccessary

public extension GoogleAccountID {
    var refreshGoogleSession: Session? { get async throws {
        try await SessionStore.shared.session(id: self, forceRefresh: false)?.refresh
    } }
}

public extension Session {
    var refresh: Session { get async throws {
        _ = try await _gtmSession._refresh()
        return self
    } }
}

// MARK: - Remove Session
@MainActor
public extension GoogleAccountID {
    func removeSession() -> Session? { SessionStore.shared.remove(id: self) }
}
