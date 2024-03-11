//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL
import JetEmailID

// Session new remove
@MainActor
extension SessionStore {
    
    func session(id: MicrosoftAccountID, forceRefresh: Bool) async throws -> MicrosoftSession {
        if forceRefresh {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let msalSession = try await MicrosoftClient.shared.refresh(id: id)
        
        return try insert(msalSession: msalSession, forceReplacing: true)
    }
    
    func insert(msalSession: MSALSession, forceReplacing: Bool) throws -> MicrosoftSession {
        let (id, username) = try msalSession.accountIDAndUsername
        
        if !forceReplacing {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let session = MicrosoftSession(accountID: id, username: username, msalSession: msalSession)
        self[id] = session
        return session
    }
    
    func remove(id: MicrosoftAccountID) -> MicrosoftSession? {
        let session = self[id]
        self[id] = nil
        return session
    }
}
