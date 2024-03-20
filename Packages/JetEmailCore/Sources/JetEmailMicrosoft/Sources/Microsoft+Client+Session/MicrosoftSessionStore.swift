//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//

@preconcurrency import MSAL
import Observation
import JetEmailData

@MainActor
@Observable
class SessionStore {
    var rawValue = [MicrosoftAccountID: MicrosoftSession]()
    
    subscript(id: MicrosoftAccountID) -> MicrosoftSession? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
}

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
        let account = try msalSession.outerAccount
        
        if !forceReplacing {
            if let session = SessionStore.shared[account.id] { return session }
        }
        
        let session = MicrosoftSession(account: account, msalSession: msalSession)
        self[account.id] = session
        return session
    }
    
    func remove(id: MicrosoftAccountID) -> MicrosoftSession? {
        let session = self[id]
        self[id] = nil
        return session
    }
}

