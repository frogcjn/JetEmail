//
//  Microsoft+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import Foundation
import Google
import Microsoft


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
