//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL
import JetEmail_ID

// Session new remove
@MainActor
extension SessionStore {
    
    func session(id: MicrosoftAccountID, forceRefresh: Bool) async throws -> Session {
        if forceRefresh {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let msalSession = try await Client.shared.refresh(id: id)
        
        return try insert(msalSession: msalSession, forceReplacing: true)
    }
    
    func insert(msalSession: MSALSession, forceReplacing: Bool) throws -> Session {
        let (id, username) = try msalSession.accountIDAndUsername
        
        if !forceReplacing {
            if let session = SessionStore.shared[id] { return session }
        }
        
        let session = Session(accountID: id, username: username, msalSession: msalSession)
        self[id] = session
        return session
    }
    
    func remove(id: MicrosoftAccountID) -> Session? {
        let session = self[id]
        self[id] = nil
        return session
    }
}
