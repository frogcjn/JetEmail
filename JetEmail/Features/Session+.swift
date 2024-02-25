//
//  Microsoft+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import Foundation


extension Microsoft.Session {
    static subscript(id: Microsoft.ID) -> Microsoft.Session? {
        get {
            guard case .microsoft(let session)? = AccountAttributesStore[id.modelID].session else { return nil }
            return session
        }
        set { AccountAttributesStore[id.modelID].session = newValue.map(Session.microsoft) }
    }
}

extension Google.Session {
    static subscript(id: Google.ID) -> Google.Session? {
        get {
            guard case .google(let session)? = AccountAttributesStore[id.modelID].session else { return nil }
            return session
        }
        set { AccountAttributesStore[id.modelID].session = newValue.map(Session.google) }
    }
}

// MARK: - Session Lazy & Refresh

extension Microsoft.MSALAccount {
    var lazySession: Microsoft.Session { get async throws {
        if let session = try Microsoft.Session[id] { session }
        else { try await refreshSession }
    } }
    
    var refreshSession: Microsoft.Session { get async throws {
        let (id, username) = try idAndUsername
        let session = Microsoft.Session(id: id, username: username, msalSession: try await _msalRefreshMSALSession)
        Microsoft.Session[id]  = session
        return session
    } }
}

extension Microsoft.MSALSession {
    var lazySession: Microsoft.Session { get throws {
        if let session = try Microsoft.Session[account.id] { session }
        else { try newSession }
    } }
    
    var newSession: Microsoft.Session {
        get throws {
            let (id, username) = try account.idAndUsername
            let session = Microsoft.Session(id: id, username: username, msalSession: self)
            Microsoft.Session[id]  = session
            return session
        }
    }
    
    /*var lazyReplacementSession: Microsoft.Session { get throws {
        if let session = try Microsoft.Session[account] {
            session._msalSession = self
            return session
        }
        return try newSession
    } }*/
}

// Microsoft.Session + refreshed

extension Microsoft.Session {
    private var isExpired: Bool {
        guard let expiresOn = _msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
    
    var refreshIfExpired: Microsoft.Session {
        get async throws {
            if !isExpired { return self }
            return try await _msalSession.account.refreshSession
            //_msalSession = try await _msalSession.refresh
            // may need interaction
            //return self
        }
    }
    
    var authorizationHeader: String { get async throws {
        try await refreshIfExpired._msalSession.authorizationHeader
    } }
    
    /*func refreshAccount(_ account: Microsoft.Account) async throws -> Microsoft.Session {
        try await sessionStore.refreshSession(account)
    }*/
    
}

// Google.SessionKeychainStore.Item -> Google.Session -> Session
extension Google.Keychain.SessionItem {
    var lazySession: Google.Session {
        if let session = Google.Session[accountID] {
            assert(session.keychainItem == keychainItem)
            return session
        }
        return newSession
    }
    
    var newSession: Google.Session {
        let session = Google.Session(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem)
        Google.Session[accountID]  = session
        return session
    }
    
    /*var lazyReplacementSession: Google.Session {
        if let session = Google.Session[id] {
            session.gtmSession = gtmSession
            assert(session.keychainItem === keychainItem)
            return session
        }
        return newSession
    }*/
    
}

extension Account {
    
    @MainActor
    var refreshedIfExpiredSession: Session? { get async throws {
        if let session {
            switch session {
            case .microsoft(let microsoftSession):
                return .microsoft(try await microsoftSession.refreshIfExpired)
            case .google(let googleSession):
                try await googleSession.refresh()
                return .google(googleSession)
            }
        } else {
            switch modelID {
            case .microsoft(let id):
                return .microsoft(try await Microsoft.Client.shared._msalRefreshSession(id: id).lazySession)
            case .google(let id):
                return try await (Google.Client.shared.keychain.item(id: id)?.lazySession).map(Session.google)
            }
        }
    } }
}



// Microsoft.Sesion -> Account
extension Microsoft.Session {
    var account: Account { .init(modelID: modelID, username: username) }
}




// Account refreshedSession
extension Account {
    
}

// Microsoft.MSALAccount -> MSALSession
/*extension Microsoft.MSALAccount {
    func msalSession(client: Microsoft.Client) async throws -> Microsoft.MSALSession {
        try await client._msalRefresh(msalAccount: self)
    }
}*/
/*
extension Microsoft.ID {
    var refreshSession: Microsoft.MSALSession {
        get async throws {
            let client = try await Microsoft.Client.shared
            return try await client._msalClient.account(forIdentifier: string).refreshMSALSession
        }
    }
}*/


    
    /*var lazyMSALSession: Microsoft.MSALSession {
        get async throws {
            if let session = try Microsoft.MSALSession[self] { return session }
            return  try await refreshMSALSession
        }
    }*/

/*
extension Microsoft.MSALSession {
    var refresh: Microsoft.MSALSession {
        get async throws {
            try await account._msalRefreshMSALSession
        }
    }
}
*/

/*extension Microsoft.Session {
    var refresh: Microsoft.Session { get async throws {
        _msalSession = try await _msalSession.refresh
        return self
    } }
}*/
