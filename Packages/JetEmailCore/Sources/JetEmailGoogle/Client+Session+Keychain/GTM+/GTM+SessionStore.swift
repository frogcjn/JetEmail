//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import JetEmailID

// Session new remove
@MainActor
extension SessionStore {
    func session(id: GoogleAccountID, forceRefresh: Bool) async throws -> GoogleSession? {
        if !forceRefresh {
            if let session = SessionStore.shared[id] { return session }
        }
        
        guard let sessionItem = try await Keychain.shared.item(id: id) else {
            return SessionStore.shared[id]
        }
        
        return insert(sessionItem: sessionItem, forceReplacing: true)
    }
    
    func insert(sessionItem: Keychain.SessionItem, forceReplacing: Bool) -> GoogleSession {
        let id = sessionItem.accountID
        
        if !forceReplacing {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let session = GoogleSession(accountID: id, username: sessionItem.username, gtmSession: sessionItem.gtmSession, keychainItem: sessionItem.keychainItem)
        self[id]  = session
        return session
    }
    
    func remove(id: GoogleAccountID) -> GoogleSession? {
        let session = self[id]
        self[id] = nil
        return session
    }
}
