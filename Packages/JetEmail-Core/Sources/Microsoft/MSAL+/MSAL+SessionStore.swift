//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL

// Session new remove
@MainActor
extension SessionStore {

    func insert(msalSession: MSALSession, forceReplacing: Bool) async throws -> Session {
        try await insert(id: msalSession.accountID, forceReplacing: forceReplacing, msalSession: msalSession)
    }
    
    func insert(id: ID, forceReplacing: Bool, msalSession: MSALSession? = nil) async throws -> Session {
        if !forceReplacing {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let msalSession = if let msalSession { msalSession } else { try await Client.shared._forceRefresh(id: id) }
        let (id, username) = try msalSession.account.idAndUsername
        
        if !forceReplacing {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let session = Session(accountID: id, username: username, msalSession: msalSession)
        self[id] = session
        return session

    }
    
    func remove(id: ID) throws -> Session? {
        let session = self[id]
        self[id] = nil
        return session
    }
}
