//
//  Microsoft+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import Foundation
import Google
import Microsoft
@preconcurrency import MSAL

@MainActor
extension Account.ModelID {
    
    var session: Session? {
        get {
            switch self {
            case .microsoft(let id): Microsoft.SessionStore[id].map(Session.microsoft)
            case .google(let id): Google.SessionStore[id].map(Session.google)
            }
        }
        nonmutating set {
            switch newValue {
            case .microsoft(let ms): Microsoft.SessionStore[ms.accountID] = ms
            case .google(let google): Google.SessionStore[google.accountID] = google
            case nil:
                switch self {
                case .microsoft(let id): Microsoft.SessionStore[id] = nil
                case .google(let id): Google.SessionStore[id] = nil
                }
            }
        }
    }
    
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
            switch self {
            case .microsoft(let id):
                return .microsoft(try await Microsoft.Client.shared._msalRefreshSession(id: id).lazySession)
            case .google(let id):
                return try await (Google.Keychain.shared.item(id: id)?.lazySession).map(Session.google)
            }
        }
    } }
}


