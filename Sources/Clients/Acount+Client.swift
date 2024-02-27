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
    
    var session: Session? {
        get {
            switch self.modelID {
            case .microsoft(let id): Microsoft.SessionStore[id].map(Session.microsoft)
            case .google(let id): Google.SessionStore[id].map(Session.google)
            }
        }
        set {
            switch newValue {
            case .microsoft(let ms): Microsoft.SessionStore[ms.accountID] = ms
            case .google(let google): Google.SessionStore[google.accountID] = google
            case nil:
                switch self.modelID {
                case .microsoft(let id): Microsoft.SessionStore[id] = nil
                case .google(let id): Google.SessionStore[id] = nil
                }
            }
        }
    }
    
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



// Google.Session -> Account, KeychainItem*/
extension Google.Session {
    var account: Account { .init(modelID: modelID, username: username) }
    // var item: Google.Keychain.SessionItem { .init(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem) }
}

